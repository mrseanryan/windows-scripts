using System;
using System.IO;
using System.Text;
using Yahoo.Yui.Compressor;

namespace CustomBundler
{
    public enum FileType { Unknown, CSS, JavaScript, CustomBundleJs, CustomBundleCss };

    public class Bundler
    {
        public void MinimiseFileToFile(string path, out string outPath)
        {
            Output.WriteLine("Minimising the file " + path);

            path = MakePathAbsolute(path);
            if (!File.Exists(path))
            {
                throw new ArgumentException("Could not find the path:" + path);
            }

            string text = ReadTextFromFile(path);

            FileType fileType = PathParser.GetFileType(path);
            StringBuilder sb = MinimiseTextToText(text, fileType);

            outPath = GenerateOutPathForMinimised(path, fileType);

            WriteTextToFile(sb.ToString(), outPath);

            Output.WriteLine("Minimised to: " + outPath);
        }

        private StringBuilder MinimiseTextToText(string text, FileType fileType)
        {
            ICompressor compressor = CreateCompressor(fileType);

            string compressed = compressor.Compress(text);

            return new StringBuilder(compressed);
        }

        private string ReadTextFromFile(string path)
        {
            return File.ReadAllText(path);
        }

        private string MakePathAbsolute(string path)
        {
            if (!Path.IsPathRooted(path))
            {
                path = Path.Combine(Directory.GetCurrentDirectory(), path);
            }

            return path;
        }

        private void WriteTextToFile(string compressed, string outPath)
        {
            if (File.Exists(outPath) && ((File.GetAttributes(outPath) & FileAttributes.ReadOnly) != 0))
            {
                File.SetAttributes(outPath, FileAttributes.Normal); //remove readonly attribute
            }

            File.WriteAllText(outPath, compressed);
        }

        private string GenerateOutPathForMinimised(string path, FileType fileType)
        {
            path = Path.Combine(Path.GetDirectoryName(path), Path.GetFileNameWithoutExtension(path));

            string newExt = "";
            switch (fileType)
            {
                case FileType.CSS:
                    newExt = ".min.css";
                    break;
                case FileType.JavaScript:
                    newExt = ".min.js";
                    break;
                default:
                    throw new InvalidOperationException("Cannot generate a mimimised out path for file: " + path);
            }

            return path + newExt;
        }

        private ICompressor CreateCompressor(string path, out FileType fileType)
        {
            fileType = PathParser.GetFileType(path);

            return CreateCompressor(fileType);
        }

        private ICompressor CreateCompressor(FileType fileType)
        {
            ICompressor comp;
            switch (fileType)
            {
                case FileType.CSS:
                    comp = new CssCompressor();
                    break;
                case FileType.JavaScript:
                    comp = new JavaScriptCompressor();
                    break;
                default:
                    throw new InvalidOperationException("Unrecognised file type for compressing: " + fileType);
            }

            ConfigureCompressor(comp);

            return comp;
        }

        /// <summary>
        /// set some default settings for the desired behaviour.
        /// </summary>
        /// <param name="comp"></param>
        private void ConfigureCompressor(ICompressor comp)
        {
            if (comp is IJavaScriptCompressor)
            {
                IJavaScriptCompressor jsComp = comp as IJavaScriptCompressor;
                jsComp.CompressionType = CompressionType.Standard;
                jsComp.DisableOptimizations = true;
                //TODO output errors - jsComp.ErrorReporter
                jsComp.IgnoreEval = false; //allow eval to pass through
                jsComp.ObfuscateJavascript = false;
                jsComp.PreserveAllSemicolons = true;
                //TODO would be nice to keep comments!
            }
            else if (comp is ICssCompressor)
            {
                CssCompressor cssComp = comp as CssCompressor;
                cssComp.CompressionType = CompressionType.Standard;
                cssComp.RemoveComments = false;
            }
            else
            {
                throw new ArgumentException("Unrecognised Compressor");
            }
        }

        public void ProcessBundle(string bundleBaseDirPath, string bundlePath, out string outPath)
        {
            Output.WriteLine("Processing the bundle file " + bundlePath);
            /*
            if (bundleBaseDirPath.EndsWith(@"\"))
            {
                bundleBaseDirPath = bundleBaseDirPath.Substring(0, bundleBaseDirPath.Length - 1);
            }*/

            BundleInfo bundle = BundleInfo.LoadFromXmlFile(bundleBaseDirPath, bundlePath);

            StringBuilder sb = ConcatenateFiles(bundle);

            //write out un-minimised file:
            string unMinText = sb.ToString();
            WriteTextToFile(unMinText, bundle.GetOutPath());

            outPath = bundle.GetOutPath();
            Output.WriteLine("Output written to: " + outPath);

            //now write out the minimsed file:
            if (bundle.IsMinimising)
            {
                sb = MinimiseTextToText(unMinText, bundle.ContainedType);

                //add back the removed header comment:
                string minText;
                if (bundle.IsRemovingCommentsOnMinimize)
                {
                    minText = CreateCommentText(GetBundlingHeader()) + sb.ToString();
                }
                else
                {
                    minText = sb.ToString();
                }
                string minimisedOutPath = GetPathForMinimised(bundle.GetOutPath());
                WriteTextToFile(minText, minimisedOutPath);

                Output.WriteLine("Minimised output written to: " + minimisedOutPath);
            }
        }

        private StringBuilder ConcatenateFiles(BundleInfo bundle)
        {
            StringBuilder sb = new StringBuilder();

            sb.AppendLine(CreateCommentText(GetBundlingHeader()));

            string fileSep = GetFileSeparatorForBundle(bundle.Type);
            foreach(string path in bundle.FilePaths)
            {
                sb.AppendLine(CreateCommentText(GetFileSummary(path)));
                sb.AppendLine(File.ReadAllText(path));
                if (!string.IsNullOrEmpty(fileSep))
                {
                    sb.Append(fileSep);
                }
            }

            return sb;
        }

        private string CreateCommentText(string text)
        {
            return "/*" + text + "*/";
        }

        private string GetFileSummary(string path)
        {
            return Path.GetFileName(path);
        }

        private string GetBundlingHeader()
        {
            return string.Format("Bundled by CustomBundler on machine {0} at {1}", Environment.MachineName, DateTime.Now);
        }

        /// <summary>
        /// get the appropriate separator, to place between files, within the bundle.
        /// </summary>
        /// <param name="fileType"></param>
        /// <returns></returns>
        private string GetFileSeparatorForBundle(FileType fileType)
        {
            switch(fileType)
            {
                case FileType.Unknown:
                    throw new ArgumentException();
                case FileType.CustomBundleCss:
                    return "";
                case FileType.CustomBundleJs:
                    return ";"; //prevents missing semicolon propogating to the next file
                default:
                    throw new ArgumentException();
            }
        }

        public string GetPathForMinimised(string path)
        {
            path = MakePathAbsolute(path);
            FileType type = PathParser.GetFileType(path);

            return GenerateOutPathForMinimised(path, type);
        }
    }
}
