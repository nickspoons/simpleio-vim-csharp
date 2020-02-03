using System;

namespace simpleio {
   public static class Program {
      public static void Main() {
         Console.WriteLine("Started server");

         var line = Console.ReadLine();
         while (!string.IsNullOrEmpty(line)) {
            Console.WriteLine($"We received: {line.ToUpper()}");
            line = Console.ReadLine();
         }
      }
   }
}
