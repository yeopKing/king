package king.controller

import king.service.KakaoPayService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.*

@RequestMapping("/kakaoPay")
@Controller
class KakaoController {

    @Autowired
    val kakaopayService: KakaoPayService? = null

    @PostMapping("/kakaoPayInquiry")
    fun kakaoPay(): String? {
        return "redirect:" + kakaopayService?.kakaoPayReady()
    }

    @RequestMapping("/kakaoPaySuccess", method = arrayOf(RequestMethod.GET))
    @ResponseBody
    fun kakaoPaySuccess(@RequestParam("pg_token") pg_token: String, model: Model?) {
        println("kakaoPaySuccess get............................................");
        println("kakaoPaySuccess pg_token : " + pg_token);

        model?.addAttribute("info", kakaopayService?.kakaoPayInfo(pg_token));


    }
}