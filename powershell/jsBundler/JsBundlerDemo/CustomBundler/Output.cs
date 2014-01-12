using System;

namespace CustomBundler
{
    enum Verbosity { Normal, Verbose }

    class Output
    {
        internal static void Write(Exception ex)
        {
            Output.WriteLine(ex.Message + Environment.NewLine + 
                    ex.StackTrace
                    );
            if(ex.InnerException != null)
            {
                Output.WriteLine("Inner exception");
                Output.Write(ex.InnerException);
            }
        }

        internal static void WriteLine(string text, Verbosity verb = Verbosity.Normal)
        {
            if (IsVerboseEnough(verb))
            {
                Console.WriteLine(GetAppTitle() + ": " + text);
            }
        }

        private static bool IsVerboseEnough(Verbosity verb)
        {
            if (verb == Verbosity.Verbose)
            {
                return IsVerbose;
            }
            if (verb == Verbosity.Normal)
            {
                return true;
            }
            throw new ArgumentException("Unhandled verbosity level:" + verb);
        }

        private static string GetAppTitle()
        {
            return "CustomBundler";
        }

        internal static void WriteLineNoPrefix(string text)
        {
            Console.WriteLine(text);
        }

        public static bool IsVerbose { get; set; }
    }
}
