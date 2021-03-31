package king.dao

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import kotlin.Int as Int

interface HomeDao {
    fun insert(data: MutableMap<String, String>?): Int?
}

class HomeDaoImpl : HomeDao {
    @Autowired
    var template: JdbcTemplate? = null


    override fun insert(data: MutableMap<String, String>?): Int? {
//dddd
        try {


            var sql =
                    "    INSERT INTO `user` ( \n" +
                    "    accountId, password, name,tel1, tel2,\n" +
                    "    address, detailAddress,rzipcode ,email,updateDate)\n" +
                    "    VALUES (?,?,?,?,?, ?,?,?,?,CURRENT_TIMESTAMP())"

            val update = template?.update(sql,
                    data!!["accountId"], //사용자아이디
                    BCryptPasswordEncoder().encode(data["password"]),//비밀번호
                    data["name"] ?: "",//이름
                    data["tel1"],//전화번호1
                    data["tel2"],//전화번호2

                    data["zipcode"],//배송지 우편번호
                    data["address"] ?: "",//배송지 정보
                    data["detailAddress"] ?: "",//배송지 상세주소
                    data["email"] ?: "")!!//이메일 주소

            return 0

        } catch (e: Exception) {
            e.printStackTrace()
        }
        return null
    }
}