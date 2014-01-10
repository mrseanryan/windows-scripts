using System;

namespace CustomBundler
{
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

        internal static void WriteLine(string text)
        {
            Console.WriteLine(GetAppTitle() + ": " + text);
        }

        private static string GetAppTitle()
        {
            return "CustomBundler";
        }
    }
}
