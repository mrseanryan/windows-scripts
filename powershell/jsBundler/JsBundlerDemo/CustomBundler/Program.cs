
using System;
namespace CustomBundler
{
    class Program
    {
        static int Main(string[] args)
        {
            try
            {
                if (args.Length != 1 && args.Length != 2)
                {
                    ShowUsage();
                    return 1;
                }

                if (args.Length == 1)
                {
                    string filePath = args[0];

                    Bundler bun = new Bundler();
                    string outPath;
                    bun.MinimiseFileToFile(filePath, out outPath);
                }
                else if (args.Length == 2)
                {
                    string bundlePath = args[0];
                    string baseDirPath = args[1];

                    Bundler bun = new Bundler();
                    string outPath;
                    bun.ProcessBundle(baseDirPath, bundlePath, out outPath);
                }
                else
                {
                    throw new ApplicationException("Unexpected number of arguments");
                }
            }
            catch (Exception ex)
            {
                Output.Write(ex);
                return 666; //NOT ok
            }

            return 0; //ok
        }

        private static void ShowUsage()
        {
            Output.WriteLine("CustomBundler " + typeof(Program).Assembly.GetName().Version);
            Output.WriteLine("USAGE: CustomBuilder <path to Web Essentials bundle file> <path to base directory to look for files>");
            Output.WriteLine("OR: CustomBuilder <path to JavaScript file>");
            Output.WriteLine("OR: CustomBuilder <path to CSS file>");
            Output.WriteLine("");
            Output.WriteLine("If a bundle file is given, then appropriate bundle output is generated. Minimising is on/off according to the setting within the bundle file.");
            Output.WriteLine("If a single JavaScript or CSS file is given, then an equivalent minimised file is output.");
        }
    }
}
