package king.service

import jdk.nashorn.internal.runtime.regexp.joni.Config.log
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
class KakaoPayServiceImpl {

    private val HOST = "https://kapi.kakao.com"

    val restTemplate : RestTemplate? = null
    val headers : HttpHeaders? = null
    var params: MultiValueMap<String, String> = LinkedMultiValueMap()

    fun kakaoHeader(): String {
        // 서버로 요청할 headers
        headers?.add("Authorization", "KakaoAK" + "6490c2593f35c9a06404f2e98157d7f7")
        headers?.add("Accept", MediaType.APPLICATION_JSON_UTF8_VALUE);
        headers?.add("Content-Type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charset=UTF-8");

        // 서버로 요청할 Body
        params?.add("cid", "TC0ONETIME");
        params?.add("partner_order_id", "1001");
        params?.add("partner_user_id", "gorany");
        params?.add("item_name", "갤럭시S9");
        params?.add("quantity", "1");
        params?.add("total_amount", "2100");
        params?.add("tax_free_amount", "100");
        params?.add("approval_url", "http://localhost:8081/kakaoPaySuccess");
        params?.add("cancel_url", "http://localhost:8081/kakaoPayCancel");
        params?.add("fail_url", "http://localhost:8081/kakaoPaySuccessFail");

        val body = HttpEntity(params, headers)

        try {

            var kakaoPay : VO.kakaoPay? = restTemplate!!.postForObject(URI("$HOST/v1/payment/ready"), body, VO.kakaoPay::class.java)

//            return kakaoPay.getNext_redirect_pc_url()
        } catch (e: RestClientException) {
            e.printStackTrace()
        } catch (e: URISyntaxException) {
            e.printStackTrace()
        }

        return "/pay"


    }


}

