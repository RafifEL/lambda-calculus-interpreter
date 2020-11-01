Reffering to : https://github.com/Ema93sh/lambda-calculus-interpreter/blob/master/README.md

# Church Numeral Intepretation

Repo ini merupakan modifikasi dari repo [lambda-calculus-intepreter](https://github.com/Ema93sh/lambda-calculus-interpreter). Repo ini menambahkan input digit bilangan bulat dari 0 - 9, operasi pertambahan dengan simbol +, dan operasi perkalian dengan simbol *. Input tersebut akan diterjemahkan menjadi format Church Numeral dan dilakukan inferensi lambda calculus untuk mendapatkan hasil operasi bilangan dari input yang diberi dalam format church numeral dan diterjemahkan kembali ke format bilangan bulat.



## Modifikasi

1. Penambahan kondisi pada parser untuk menerjemahkan angka.

   ```haskell
   parseExpr :: String -> Either ParseError LExpr
   parseExpr s = 
       if head s `elem` ['0'..'9']
           then let operation = toChurchNumeral s
                in parse lambdaExpr "" operation
       else parse lambdaExpr "" s
   ```

   Fungsi parseExpr adalah fungsi untuk mem-parse ekspresi lambda calculus. Saya memodifikasi dengan menambahkan kondisi yang memeriksa apakah indeks pertama string tersebut adalah digit. Jika iya maka diproses terlebih dahulu agar menjadi format church numeral, lalu dimasukkan ke dalam fungsi parse dengan parameter seperti diatas.

   

2. Menambahkan fungsi penerjemah digit ke format Church Numeral.

   Saya menambahkan sebuah modul Numeral yang berfungsi untuk menerjemahkan digit dan operasi pertambahan (+) dan perkalian (*) ke dalam bentuk church numeral.

   Untuk mengubah digit menjadi church numeral, saya membuat fungsi rekursif sebagai berikut.

   ``` haskell
   intToChurchNumeral :: Int -> [Char]
   intToChurchNumeral n = "(\\sz." ++ intToChurchNumeralHelper n ++ ")"
   
   intToChurchNumeralHelper :: Int -> String
   intToChurchNumeralHelper 0 = "z"
   intToChurchNumeralHelper n = "s(" ++ intToChurchNumeralHelper (n-1) ++ ")"
   ```

   Kemudian saya membuat fungsi untuk untuk mengubah digit dan operasi pertambahan dan perkalian ke Church Numeral dengan fungsi berikut.

   ```haskell
   helperToChurchNumeral :: [Char] -> [Char] -> [Char]
   helperToChurchNumeral s acc
       | s == "" = acc
       | head s == '+' =
           let newAcc = acc ++ "(\\wyx.y(wyx))"
           in helperToChurchNumeral (tail s) newAcc
       | head s == '*' =
           let newAcc = "(\\xyz.x(yz))(" ++ acc ++ ")"
           in helperToChurchNumeral (tail s) newAcc
       | otherwise =
           let number = intToChurchNumeral (digitToInt (head s))
               newAcc = acc ++ number
           in helperToChurchNumeral (tail s) newAcc
   ```

   fungsi ini menggunakan akumulator (acc) untuk menampung string yang terb

   

3. Penerjemahan Kembali Church Numeral menjadi bilangan bulat biasa.

   Church Numeral dalam repo ini direprentasikan dalam format berikut.

   ```
   \ = simbol untuk lambda
   0 ≡ (λsz.z)
   1 ≡ (λsz.s(z))
   2 ≡ (λsz.s(s(z)))
   ```

   Dapat dilihat dari format diatas, setiap kemunculan argumen pertama variabel pertama dalam body dalam kumpulan lambda calculus diatas merpresentasikan bilangan bulat. Maka dari itu saya memanfaatkan pattern ini dalam menerjemahkan kembali lambda calculus tersebut. berikut fungsi yang saya gunakan.

   ```haskell
   churchtoIntApprox :: String -> String
   churchtoIntApprox s
     | isInfixOf "Parse Error!" s = ""
     | otherwise = 
       let filt_lambda = filter (\x -> x == (head $ tail s)) s
           count_num = show ((length filt_lambda) - 1)
       in "Numeral Approx = " ++ count_num ++ "\n"
   ```

   

4. 

