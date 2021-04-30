package king.value

import net.minidev.json.JSONArray
import java.util.*


object VO {
    data class KakaoPayArrroValVO(
            private var aid: String,
            private var tid: String,
            private var cid: String,
            private var sid: String,
            private var partner_order_id: String,
            private var partner_user_id: String,
            private var partner_method_type: String,
            private var amount: AmountVO,
            private var card_info: CardVO,
            private var item_name: String,
            private var item_code: String,
            private var payload: String,
            private var quantity: Integer,
            private var tax_free_amount: Integer,
            private var vat_amount: Integer,
            private var created_at: Date,
            private var approved_at: Date
    )

    data class kakaoPayReadyVO(
            var tid: String,
            var next_redirect_pc_url: String,
            var created_at: Date
    )

    data class AmountVO(
            private var total: Integer,
            private var tax_free: Integer,
            private var vat: Integer,
            private var point: Integer,
            private var discount: Integer
    )

    data class CardVO(
            private var purchase_corp: String,
            private var purchase_corp_code: String,
            private var issuer_corp: String,
            private var issuer_corp_code: String,
            private var bin: String,
            private var card_type: String,
            private var install_month: String,
            private var approved_id: String,
            private var card_mid: String,
            private var interest_free_install: String,
            private var card_item_code: String
    )

}
