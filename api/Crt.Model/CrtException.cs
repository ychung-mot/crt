using System;

namespace Crt.Model
{
    public class CrtException : Exception
    {
        public CrtException(string message)
            : base(message)
        {
        }
    }
}
