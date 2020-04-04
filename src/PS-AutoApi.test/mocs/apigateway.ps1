@{
    GetRoot= [PSCustomObject]@{
        resource="/"
        path="/"
        httpMethod="GET"
        headers=$null
        multiValueHeaders=$null
        queryStringParameters=$null
        multiValueQueryStringParameters=$null
        pathParameters=$null
        stageVariables=$null
        requestContext=$null
        body=$null
        isBase64Encoded=$False
    }
    PostRoot= [PSCustomObject]@{
        resource="/"
        path="/"
        httpMethod="POST"
        headers=$null
        multiValueHeaders=$null
        queryStringParameters=$null
        multiValueQueryStringParameters=$null
        pathParameters=$null
        stageVariables=$null
        requestContext=$null
        body='{"foo":"bar"}'
        isBase64Encoded=$False
    }
    SlackChallenge = [PSCustomObject]@{
        resource="/"
        path="/"
        httpMethod="POST"
        headers=$null
        multiValueHeaders=$null
        queryStringParameters=$null
        multiValueQueryStringParameters=$null
        pathParameters=$null
        stageVariables=$null
        requestContext=$null
        body='{"token":"LPTQSprci2uRJSL82r2KTMyV","challenge":"I0ehPNmr1EGZfgBFIHEj6lhD2OksLaOyWupJfZasVCGbvKzWNM4O","type":"url_verification"}' | ConvertFrom-Json
        isBase64Encoded=$False
    }
}