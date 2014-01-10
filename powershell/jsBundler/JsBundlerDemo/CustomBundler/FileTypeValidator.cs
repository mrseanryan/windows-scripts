using System;

namespace CustomBundler
{
    class FileTypeValidator
    {
        internal static void ValidateBundleMatches(FileType bundleFileType, FileType fileType)
        {
            bool isValid = false;
            switch(bundleFileType)
            {
                case FileType.CustomBundleJs:
                    isValid = fileType == FileType.JavaScript;
                    break;
                case FileType.CustomBundleCss:
                    isValid = fileType == FileType.CSS;
                    break;
                default:
                    throw new ArgumentException("Not a recognised type of bundle: " + bundleFileType);
            }

            if (!isValid)
            {
                throw new ApplicationException("The file type " + fileType + " is not appropriate for the bundle file type: " + bundleFileType + ". Is there an error in the bundle file?");
            }
        }

        internal static FileType GetFileTypeForBundle(FileType type)
        {
            switch(type)
            {
                case FileType.CustomBundleJs:
                    return FileType.JavaScript;
                case FileType.CustomBundleCss:
                    return FileType.CSS;
                default:
                    throw new ArgumentException("Not a recognised type of bundle file");
            }
        }
    }
}
