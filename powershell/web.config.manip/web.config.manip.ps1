$path = 'test.data\web.07615.config'

$results = 0

$file = gi $path
$xml = [xml](gc $path)
$xml | Select-Xml "//identity" | 
       Foreach {
            #set impersonate to false, so that the IDS proxy request will be accepted by the IIS on the shell.maps.com ArcGIS box
            $_.Node.SetAttribute("impersonate", "false")
            $results = 1
       }
if($results -eq 1){
    $xml.Save($file.FullName)
}
