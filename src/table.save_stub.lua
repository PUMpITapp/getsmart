do
   -- declare local variables
   --// exportstring( string )
   --// returns a "Lua" portable version of the string
   local function exportstring( s )
      return string.format("%q", s)
   end

   --// The Save Function
   function table.save(  tbl,filename )
      return nil
   end
   
   -- Assumes table.load from profiles.lua
   function table.load( sfile )
     return {
       ['player1'] = {
         name = 'Julbin',
         isActive = 1,
         mathGame = {
           userLevel = 0,
           additionPoints = 1,
           subtractionPoints = 1,
           multiplicationPoints = 1,
           divisionPoints = 1
         },
         geographyGame = {
           userLevel = 1,
           points = 0
         },
         spellingGame = {
           userLevel = 1,
           points = 0
         },
         memoryGame  = {
           userLevel = 1,
           points = 0
         }
       },
       ['player2'] = {
         name = '',
         isActive = 0,
         mathGame = {
           userLevel = 0,
           additionPoints = 1,
           subtractionPoints = 1,
           multiplicationPoints = 1,
           divisionPoints = 1
         },
         geographyGame = {
           userLevel = 1,
           points = 0
         },
         spellingGame = {
           userLevel = 1,
           points = 0
         },
         memoryGame  = {
           userLevel = 1,
           points = 0
         }
       },
       ['player3'] = {
         name = 'Artrik',
         isActive = 1,
         mathGame = {
           userLevel = 0,
           additionPoints = 1,
           subtractionPoints = 1,
           multiplicationPoints = 1,
           divisionPoints = 1
         },
         geographyGame = {
           userLevel = 1,
           points = 0
         },
         spellingGame = {
           userLevel = 1,
           points = 0
         },
         memoryGame  = {
           userLevel = 1,
           points = 0
         }
       },
       ['player4'] = {
         name = 'Jachael',
         isActive = 1,
         mathGame = {
           userLevel = 0,
           additionPoints = 1,
           subtractionPoints = 1,
           multiplicationPoints = 1,
           divisionPoints = 1
         },
         geographyGame = {
           userLevel = 1,
           points = 0
         },
         spellingGame = {
           userLevel = 1,
           points = 0
         },
         memoryGame  = {
           userLevel = 1,
           points = 0
         }
       },
     }
   end
-- close do
end