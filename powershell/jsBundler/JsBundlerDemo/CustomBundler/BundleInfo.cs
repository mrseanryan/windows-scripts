using System.Collections.Generic;
using System.IO;
using System.Xml;

namespace CustomBundler
{
    /// <summary>
    /// Describes the contents of a bundle.
    /// </summary>
    class BundleInfo
    {
        List<string> filePaths = new List<string>();
        FileType type = FileType.Unknown;
        bool isMinimising = false;
        string outFilepath;
        FileType containedType;

        private BundleInfo(FileType type)
        {
            this.type = type;

            this.containedType = FileTypeValidator.GetFileTypeForBundle(type);
        }

        public FileType Type
        {
            get
            {
                return type;
            }
        }

        /// <summary>
        /// The path to the main (un-minimised) bundle file.
        /// </summary>
        /// <returns></returns>
        internal string GetOutPath()
        {
            return outFilepath;
        }

        public bool IsMinimising 
        {
            get
            {
                return this.isMinimising;
            }
        }

        /// <summary>
        /// reads from a standard Web Essentials stlye bundle file
        /// </summary>
        /// <param name="bundleBaseDirPath">the base directory, in which to look for the files that the bundle will contain.</param>
        /// <param name="bundlePath">The path to the .custombundle file.</param>
        /// <returns></returns>
        internal static BundleInfo LoadFromXmlFile(string bundleBaseDirPath, string bundlePath)
        {
            BundleInfo bundle = new BundleInfo(PathParser.GetFileType(bundlePath));

            XmlDocument doc = new XmlDocument();
            doc.Load(bundlePath);

            XmlNode node = doc.SelectSingleNode("/bundle");
            string outFilename = GenerateOutFilename(bundlePath);
            foreach(XmlAttribute attr in node.Attributes)
            {
                if(attr.Name == "minify")
                {
                    bundle.isMinimising = attr.Value == "true";
                }
                if(attr.Name == "output")
                {
                    outFilename = attr.Value;
                }
            }

            bundle.outFilepath = Path.Combine(Path.GetDirectoryName(bundlePath), outFilename);

            XmlNodeList fileNodes = doc.SelectNodes("/bundle/file");
            foreach(XmlNode fileNode in fileNodes)
            {
                string relPath = fileNode.InnerText;
                if (relPath.StartsWith("/"))
                {
                    relPath = relPath.Substring(1);
                }
                relPath = relPath.Replace("/", "\\");

                //get the absolute path to the file:
                string absPath = Path.Combine(bundleBaseDirPath, relPath);
                bundle.filePaths.Add(absPath);

                //check that type of the file, matches the type of the bundle:
                FileType typeOfFile = PathParser.GetFileType(absPath);
                FileTypeValidator.ValidateBundleMatches(bundle.Type, typeOfFile);
            }

            return bundle;
        }

        private static string GenerateOutFilename(string bundlePath)
        {
            bundlePath = bundlePath.Replace(".custombundle", "");
            return Path.GetFileName(bundlePath);
        }

        /// <summary>
        /// Resolved absolute paths to the files that the bundle contains.
        /// </summary>
        internal List<string> FilePaths
        {
            get
            {
                return filePaths;
            }
        }

        public FileType ContainedType 
        {
            get
            {
                return containedType;
            }
        }

        public bool IsRemovingCommentsOnMinimize
        {
            get
            {
                return this.containedType == FileType.JavaScript; //YUI compressor ALWAYS removes comments in js    
            }
        }
    }
}
