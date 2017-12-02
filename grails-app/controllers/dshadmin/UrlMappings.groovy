package dshadmin

class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"(view:"/index")
        "/main"(view:"/main")
        "500"(view:'/errors/500.gsp')
        "404"(view:'/errors/404.gsp')
        "403"(view:'/errors/403.gsp')
        "405"(view:'/errors/405.gsp')
    }
}
