
function Translate($Text, $TargetLanguage)
{
    # Create a list object to store the finished translation in.
    $Translation = New-Object System.Collections.Generic.List[System.Object]

    $Uri = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=$TargetLanguage&dt=t&q=$Text"

    echo $Uri
    # Get the response from the web request, then throw a bunch of regex at it to clean it up.
    $RawResponse = (Invoke-WebRequest -Uri $Uri -Method Get).Content
    $CleanResponse = $RawResponse -split '\\r\\n' -replace '^(","?)|(null.*?\[")|\[{3}"' -split '","'

    <# 
    Selecting every odd line and adding it to the $Translation list, we recreate the full translated text.
    Credit to: http://stuckinmypowershell.blogspot.com/2013/04/powershell-diy-reading-every-other-line.html
    for the $Linenumber%2 method. Check it out to learn what's happening if it looks weird.
    #>
    $LineNumber = 0
    foreach ($Line in $CleanResponse) {
        $LineNumber++
        if($LineNumber%2) {
            $Translation.Add($Line)
        }
    }
    return $Translation
}

Add-Type -AssemblyName System.Speech
$SpeechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer
$CatFact = (ConvertFrom-Json (Invoke-WebRequest -Uri 'https://catfact.ninja/fact?max_length=140')).fact
$CatFactES=""
$CatFactES=Translate($CatFact,"es")
$SpeechSynth.Speak("Sabias que?")
echo $catFact = $CatFactES
#$SpeechSynth.Speak($CatFactES[0])



