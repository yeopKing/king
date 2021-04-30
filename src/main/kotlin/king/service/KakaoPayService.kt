package king.service

import king.value.VO
import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.MediaType
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
    private var kakaoPayArrroValVO : VO.KakaoPayArrroValVO? = null

    val headers = HttpHeaders()
    val params: MultiValueMap<String, String> = LinkedMultiValueMap()
    val restTemplate = RestTemplate()

    fun kakaoPayReady(): String? {// 결제신청 하는 함수
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
        params.add("total_amount", "100")
        params.add("tax_free_amount", "100")
        params.add("approval_url", "http://localhost:8080/kakaoPaySuccess")
        params.add("cancel_url", "http://localhost:8080/kakaoPayCancel")
        params.add("fail_url", "http://localhost:8080/kakaoPaySuccessFail")
        val body = HttpEntity(params, headers)
        try {
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

    fun kakaoPayInfo (pg_token : String) : VO.KakaoPayArrroValVO? { //결제 하는 함수
        // 서버로 요청할 Header
        headers.add("Authorization", "KakaoAK " + "6490c2593f35c9a06404f2e98157d7f7")
        headers.add("Accept", MediaType.APPLICATION_JSON_UTF8_VALUE)
        headers.add("Content-Type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charset=UTF-8")

        params.add("cid","TC0ONETIME")
        params.add("tid", kakaoPayReadyVO?.tid)
        params.add("partner_order_id", "1001")
        params.add("partner_user_id", "gorany")
        params.add("pg_token", pg_token)
        params.add("total_amount","2100")
        val body = HttpEntity(params, headers)
        try{
            kakaoPayArrroValVO = restTemplate?.postForObject(URI(HOST + "/v1/payment/approve"),body,VO.KakaoPayArrroValVO::class.java)
            return kakaoPayArrroValVO
        }catch (e:RestClientException){
            e.printStackTrace()
        }catch (e:URISyntaxException){
            e.printStackTrace()
        }
        return null
    }

}




