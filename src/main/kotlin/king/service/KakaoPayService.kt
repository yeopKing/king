package king.service

import king.value.VO
import lombok.extern.java.Log
import org.springframework.http.*
import org.springframework.stereotype.Service
import org.springframework.util.LinkedMultiValueMap
import org.springframework.util.MultiValueMap
import org.springframework.web.client.RestClientException
import org.springframework.web.client.RestTemplate
import java.net.URI
import java.net.URISyntaxException


@Service
class KakaoPayService {
    private var kakaoPayReadyVO: VO.kakaoPayReadyVO? = null
    val headers = HttpHeaders()
    val params: MultiValueMap<String, String> = LinkedMultiValueMap()

    fun kakaoPayReady(): String? {
        val restTemplate = RestTemplate()

        // 서버로 요청할 Header
        headers.add("Authorization", "KakaoAK " + "6490c2593f35c9a06404f2e98157d7f7")
        headers.add("Accept", MediaType.APPLICATION_JSON_UTF8_VALUE)
        headers.add("Content-Type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charset=UTF-8")

        // 서버로 요청할 Body
        params.add("cid", "TC0ONETIME")
        params.add("partner_order_id", "1001")
        params.add("partner_user_id", "gorany")
        params.add("item_name", "갤럭시S9")
        params.add("quantity", "1")
        params.add("total_amount", "2100")
        params.add("tax_free_amount", "100")
        params.add("approval_url", "http://localhost:8080/kakaoPaySuccess")
        params.add("cancel_url", "http://localhost:8080/kakaoPayCancel")
        params.add("fail_url", "http://localhost:8080/kakaoPaySuccessFail")
        val body = HttpEntity(params, headers)
        try {
//            kakaoPayReadyVO = restTemplate?.postForObject(URI("${host}/v1/payment/ready"), body, VO.kakaoPayReadyVO::class.java)
            kakaoPayReadyVO = restTemplate?.postForObject(URI(HOST + "/v1/payment/ready"), body, VO.kakaoPayReadyVO::class.java)
            return kakaoPayReadyVO?.next_redirect_pc_url
        } catch (e: RestClientException) {
            e.printStackTrace()
        } catch (e: URISyntaxException) {
            e.printStackTrace()
        }
        return "/pay"
    }

    companion object {
        private const val HOST = "https://kapi.kakao.com"
    }
}




