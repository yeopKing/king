package king.dao

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.stereotype.Repository
import kotlin.Int as Int

interface HomeDao {
    fun insert(data: Map<String, String>?): Int?
}

@Repository
class HomeDaoImpl : HomeDao {
    @Autowired
    var template: JdbcTemplate? = null


    override fun insert(data: Map<String, String>?): Int? {
        try {

            var sql =
                    "    INSERT INTO `user` ( \n" +
                    "    accountId, password, name,tel1, tel2,\n" +
                    "    address, detailAddress,zipcode ,email,updateDate)\n" +
                    "    VALUES (?,?,?,?,?, ?,?,?,?,CURRENT_TIMESTAMP())"

                    template?.update(sql,
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
            return 777
        }
        return null
    }
}