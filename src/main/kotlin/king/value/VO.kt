package king.value

import net.minidev.json.JSONArray
import java.util.*


object VO{
    data class kakaoPay(
            var cid: String,    //가맹점 코드, 10자	O
            var cid_secret: String, //	가맹점 코드 인증키, 24자, 숫자와 영문 소문자 조합	X
            var partner_order_id: String, //	가맹점 주문번호, 최대 100자	O
            var partner_user_id: String, //	가맹점 회원 id, 최대 100자	O
            var item_name: String, //	상품명, 최대 100자	O
            var item_code: String, //	상품코드, 최대 100자	X
            var quantity: Integer, //	상품 수량	O
            var total_amount: Integer, //	상품 총액	O
            var tax_free_amount: Integer, //	상품 비과세 금액	O
            var vat_amount: Integer, //	상품 부가세 금액
            //  값을 보내지 않을 경우 다음과 같이 VAT 자동 계산
            //  (상품총액 - 상품 비과세 금액)/11 : 소숫점 이하 반올림	X
            var approval_url: String,     // 결제 성공 시 redirect url, 최대 255자	O
            var cancel_url: String,     // 결제 취소 시 redirect url, 최대 255자	O
            var fail_url: String,     // 결제 실패 시 redirect url, 최대 255자	O
            var available_cards: Array<JSONArray>, //	결제 수단으로써 사용 허가할 카드사를 지정해야 하는 경우 사용, 카카오페이와 사전 협의 필요
            //   사용 허가할 카드사 코드*의 배열  ex) ["HANA", "BC"] (기본값: 모든 카드사 허용)	X
            var payment_method_type: String, //	사용 허가할 결제 수단, 지정하지 않으면 모든 결제 수단 허용 CARD 또는 MONEY 중 하나	X
            var install_month: Integer,    //카드 할부개월, 0~12	X
            var varcustom_json: Map<String, String>    //JSON//결제 화면에 보여줄 사용자 정의 문구, 카카오페이와 사전 협의 필요
            // ex) iOS에서 사용자 인증 완료 후 가맹점 앱으로 자동 전환하는 방법(iOS만 예외 처리, 안드로이드 동작 안 함)
            //        - 다음과 같이 return_custom_url key 정보에 앱스킴을 넣어서 전송 "return_custom_url":"kakaotalk://"	X
    )

    data class kakaoPayReadyVO(
          var tid : String ,
          var next_redirect_pc_url : String ,
          var created_at : Date

    )

}