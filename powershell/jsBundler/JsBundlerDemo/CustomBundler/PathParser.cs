using System;
using System.IO;

namespace CustomBundler
{
    class PathParser
    {
        internal static FileType GetFileType(string path)
        {
            path = path.ToLower();
            string ext = Path.GetExtension(path);
            switch (ext)
            {
                case ".js":
                    return FileType.JavaScript;
                case ".css":
                    return FileType.CSS;
                case ".custombundle":
                    if (path.EndsWith(".js.custombundle"))
                    {
                        return FileType.CustomBundleJs;
                    }
                    else if (path.EndsWith(".css.custombundle"))
                    {
                        return FileType.CustomBundleCss;
                    }
                    else
                    {
                        throw new ArgumentException("Custom bundle file must be named x.js.custombundle OR x.css.custombundle");
                    }
                default:
                    throw new ArgumentException("Unrecognised file extension - file: " + path);
            }
        }
    }
}
