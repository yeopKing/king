package king.service

import king.dao.HomeDao
import org.springframework.beans.factory.annotation.Autowired

interface HomeService {
    fun join(data: MutableMap<String, String>?): Int?
}

class HomeServiceImpl : HomeService{
    @Autowired
    var homeDao : HomeDao? = null

    override fun join(data: MutableMap<String, String>?): Int? {
        return homeDao?.insert(data)
    }

}

