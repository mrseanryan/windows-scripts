
using System;
using System.Collections.Generic;
namespace CustomBundler
{
    class Program
    {
        static int Main(string[] args)
        {
            try
            {
                if (args.Length < 1 || args.Length > 3)
                {
                    ShowUsage();
                    return 1;
                }

                List<string> values;
                bool isVerbose = false;
                ParseArgs(args, out values, out isVerbose);

                Output.IsVerbose = isVerbose;

                if (values.Count == 1)
                {
                    string filePath = values[0];

                    Bundler bun = new Bundler();
                    string outPath;
                    bun.MinimiseFileToFile(filePath, out outPath);
                }
                else if (values.Count == 2)
                {
                    string bundlePath = values[0];
                    string baseDirPath = values[1];

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

        private static void ParseArgs(string[] args, out List<string> values, out bool isVerbose)
        {
            isVerbose = false;
            values = new List<string>();

            foreach (var arg in args)
            {
                if (arg.StartsWith("-"))
                {
                    //an option
                    switch (arg)
                    {
                        case "-v":
                            isVerbose = true;
                            break;
                        default:
                            throw new ArgumentException("Unrecognised option:" + arg);
                    }
                }
                else
                {
                    //a value
                    values.Add(arg);
                }
            }
        }

        private static void ShowUsage()
        {
            Output.WriteLineNoPrefix("CustomBundler " + typeof(Program).Assembly.GetName().Version);
            Output.WriteLineNoPrefix("USAGE: CustomBuilder <path to Web Essentials bundle file> <path to base directory to look for files> [OPTIONS]");
            Output.WriteLineNoPrefix("OR: CustomBuilder <path to JavaScript file> [OPTIONS]");
            Output.WriteLineNoPrefix("OR: CustomBuilder <path to CSS file> [OPTIONS]");
            Output.WriteLineNoPrefix("");
            Output.WriteLineNoPrefix("If a bundle file is given, then appropriate bundle output is generated. Minimising is on/off according to the setting within the bundle file.");
            Output.WriteLineNoPrefix("If a single JavaScript or CSS file is given, then an equivalent minimised file is output.");
            Output.WriteLineNoPrefix("");
            Output.WriteLineNoPrefix("OPTIONS:");
            Output.WriteLineNoPrefix(" -v\t\tturn on Verbose output");
        }
    }
}
