package king.controller

import king.service.HomeService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestMethod
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.ResponseBody
import javax.servlet.http.HttpSession

@Controller
@RequestMapping("/")
class HomeController {

    @Autowired
    var homeService: HomeService? = null

    @RequestMapping("/index")
    fun home(model: Model?, session: HttpSession?): String? {

        return "/index"
    }

    @RequestMapping("/about")
    fun about(model: Model?, session: HttpSession?): String? {

        return "/about"
    }

    @RequestMapping("/product")
    fun products(model: Model?, session: HttpSession?): String? {

        return "/product"
    }

    @RequestMapping("/store")
    fun store(model: Model?, session: HttpSession?): String? {

        return "/store"
    }

    @RequestMapping("/join")
    fun join(model: Model?, session: HttpSession?): String? {

        return "/join"
    }

    @RequestMapping("/pay")
    fun pay(model: Model?, session: HttpSession?): String? {

        return "/pay"
    }

    /**
     * 사용자 등록 실행
     * @param data
     * @return
     */
    @RequestMapping("/join/do", method = arrayOf(RequestMethod.POST))
    @ResponseBody
    fun doJoin(@RequestParam data: MutableMap<String, String>?): Map<String, Any?>? {
        try {
            val resultCode = homeService?.join(data)
            return mapOf("result" to 0)
        } catch (e : Exception) {
            return mapOf("result" to 777)
        }
    }

    @RequestMapping("/header")
    fun header(model: Model?, session: HttpSession?): String? {

        return "/header"
    }
}






























