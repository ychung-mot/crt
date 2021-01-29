using System;
using System.Linq;

namespace Crt.Model.Utils
{
    public static class ObjectExtension
    {
        public static void TrimStringFields(this object obj)
        {
            var fields = obj.GetType().GetProperties();

            foreach (var field in fields.Where(x => x.PropertyType == typeof(string)))
            {
                var value = field.GetValue(obj);

                if (value != null)
                {
                    field.SetValue(obj, Convert.ToString(value).Trim());
                }
            }
        }
    }
}
