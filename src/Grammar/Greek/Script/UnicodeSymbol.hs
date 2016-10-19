module Grammar.Greek.Script.UnicodeSymbol where

import Data.Either.Validation
import Grammar.Around
import Grammar.CommonTypes
import Grammar.Greek.Script.Types

data InvalidChar = InvalidChar Char
  deriving (Show)

unicodeSymbol :: ParseAround InvalidChar Char (Symbol :+ Mark :+ WordPunctuation)
unicodeSymbol = makeParseAround to from
  where
  validSymbol = Success . Left
  validMark = Success . Right . Left
  validPunct = Success . Right . Right
  invalidChar = Failure . pure . InvalidChar
  to 'Α' = validSymbol S_Α
  to 'Β' = validSymbol S_Β
  to 'Γ' = validSymbol S_Γ
  to 'Δ' = validSymbol S_Δ
  to 'Ε' = validSymbol S_Ε
  to 'Ζ' = validSymbol S_Ζ
  to 'Η' = validSymbol S_Η
  to 'Θ' = validSymbol S_Θ
  to 'Ι' = validSymbol S_Ι
  to 'Κ' = validSymbol S_Κ
  to 'Λ' = validSymbol S_Λ
  to 'Μ' = validSymbol S_Μ
  to 'Ν' = validSymbol S_Ν
  to 'Ξ' = validSymbol S_Ξ
  to 'Ο' = validSymbol S_Ο
  to 'Π' = validSymbol S_Π
  to 'Ρ' = validSymbol S_Ρ
  to 'Σ' = validSymbol S_Σ
  to 'Τ' = validSymbol S_Τ
  to 'Υ' = validSymbol S_Υ
  to 'Φ' = validSymbol S_Φ
  to 'Χ' = validSymbol S_Χ
  to 'Ψ' = validSymbol S_Ψ
  to 'Ω' = validSymbol S_Ω
  to 'α' = validSymbol S_α
  to 'β' = validSymbol S_β
  to 'γ' = validSymbol S_γ
  to 'δ' = validSymbol S_δ
  to 'ε' = validSymbol S_ε
  to 'ζ' = validSymbol S_ζ
  to 'η' = validSymbol S_η
  to 'θ' = validSymbol S_θ
  to 'ι' = validSymbol S_ι
  to 'κ' = validSymbol S_κ
  to 'λ' = validSymbol S_λ
  to 'μ' = validSymbol S_μ
  to 'ν' = validSymbol S_ν
  to 'ξ' = validSymbol S_ξ
  to 'ο' = validSymbol S_ο
  to 'π' = validSymbol S_π
  to 'ρ' = validSymbol S_ρ
  to 'σ' = validSymbol S_σ
  to 'ς' = validSymbol S_ς
  to 'τ' = validSymbol S_τ
  to 'υ' = validSymbol S_υ
  to 'φ' = validSymbol S_φ
  to 'χ' = validSymbol S_χ
  to 'ψ' = validSymbol S_ψ
  to 'ω' = validSymbol S_ω
  to '\x0300' = validMark M_Grave -- COMBINING GRAVE ACCENT
  to '\x0301' = validMark M_Acute -- COMBINING ACUTE ACCENT
  to '\x0308' = validMark M_Diaeresis -- COMBINING DIAERESIS
  to '\x0313' = validMark M_Smooth -- COMBINING COMMA ABOVE
  to '\x0314' = validMark M_Rough -- COMBINING REVERSED COMMA ABOVE
  to '\x0342' = validMark M_Circumflex -- COMBINING GREEK PERISPOMENI
  to '\x0345' = validMark M_IotaSubscript -- COMBINING GREEK YPOGEGRAMMENI
  to '\x2019' = validPunct P_RightQuote
  to x = invalidChar x

  from (Left S_Α) = 'Α'
  from (Left S_Β) = 'Β'
  from (Left S_Γ) = 'Γ'
  from (Left S_Δ) = 'Δ'
  from (Left S_Ε) = 'Ε'
  from (Left S_Ζ) = 'Ζ'
  from (Left S_Η) = 'Η'
  from (Left S_Θ) = 'Θ'
  from (Left S_Ι) = 'Ι'
  from (Left S_Κ) = 'Κ'
  from (Left S_Λ) = 'Λ'
  from (Left S_Μ) = 'Μ'
  from (Left S_Ν) = 'Ν'
  from (Left S_Ξ) = 'Ξ'
  from (Left S_Ο) = 'Ο'
  from (Left S_Π) = 'Π'
  from (Left S_Ρ) = 'Ρ'
  from (Left S_Σ) = 'Σ'
  from (Left S_Τ) = 'Τ'
  from (Left S_Υ) = 'Υ'
  from (Left S_Φ) = 'Φ'
  from (Left S_Χ) = 'Χ'
  from (Left S_Ψ) = 'Ψ'
  from (Left S_Ω) = 'Ω'
  from (Left S_α) = 'α'
  from (Left S_β) = 'β'
  from (Left S_γ) = 'γ'
  from (Left S_δ) = 'δ'
  from (Left S_ε) = 'ε'
  from (Left S_ζ) = 'ζ'
  from (Left S_η) = 'η'
  from (Left S_θ) = 'θ'
  from (Left S_ι) = 'ι'
  from (Left S_κ) = 'κ'
  from (Left S_λ) = 'λ'
  from (Left S_μ) = 'μ'
  from (Left S_ν) = 'ν'
  from (Left S_ξ) = 'ξ'
  from (Left S_ο) = 'ο'
  from (Left S_π) = 'π'
  from (Left S_ρ) = 'ρ'
  from (Left S_σ) = 'σ'
  from (Left S_ς) = 'ς'
  from (Left S_τ) = 'τ'
  from (Left S_υ) = 'υ'
  from (Left S_φ) = 'φ'
  from (Left S_χ) = 'χ'
  from (Left S_ψ) = 'ψ'
  from (Left S_ω) = 'ω'
  from (Right (Left M_Grave)) = '\x0300' -- COMBINING GRAVE ACCENT
  from (Right (Left M_Acute)) = '\x0301' -- COMBINING ACUTE ACCENT
  from (Right (Left M_Diaeresis)) = '\x0308' -- COMBINING DIAERESIS
  from (Right (Left M_Smooth)) = '\x0313' -- COMBINING COMMA ABOVE
  from (Right (Left M_Rough)) = '\x0314' -- COMBINING REVERSED COMMA ABOVE
  from (Right (Left M_Circumflex)) = '\x0342' -- COMBINING GREEK PERISPOMENI
  from (Right (Left M_IotaSubscript)) = '\x0345' -- COMBINING GREEK YPOGEGRAMMENI
  from (Right (Right P_RightQuote)) = '\x2019'
