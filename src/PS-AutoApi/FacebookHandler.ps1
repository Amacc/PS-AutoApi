class FaceBookHandler {
    [string]$ClientSecret
    [string]$RedirectUri

    [string]GetAccessToken([string]$code) {
        $facebookResponse = Invoke-RestMethod @(
            "https://graph.facebook.com/v3.2/oauth/access_token?" ,
              "client_id={app-id}",
              "&redirect_uri=$($this.RedirectUri)",
              "&client_secret=$($this.AppSecret)",
              "&code=$code"
        ).join("")
        return $facebookResponse
    }

    [string]GetUserData(){
        # `/${this.fbAuthResponse.userID}?fields=id,name,email,permissions`
        return ""
    }

    [bool]isValidAccessToken([string]$token){
        return $True
    #     GET graph.facebook.com/debug_token?
    #  input_token={token-to-inspect}
    #  &access_token={app-token-or-admin-token}
    }

}
