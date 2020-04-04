return @{
    Home = [PSCustomObject]@{
        Name="Home"
        Method="GET"
        Route ="/"
        ScriptBlock = {
            param($first,$second)
            Write-Host "First:$First"
            Write-Host "Second:$Second"
            return "Woot!"
        }
    }
    PostHandler = [PSCustomObject]@{
        Name="HandleSlackMessage"
        Method="POST"
        Route ="/"
        ScriptBlock = {
            param($Body)
            if($body){
                return $body
            }
            return "No Challenge"
        }
    }
    Health = [PSCustomObject]@{
        Name="Health"
        Route ="/health"
        ScriptBlock = {return "healthy"}
    }
}
