package king.service

import king.dao.HomeDao
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

interface HomeService {
    fun join(data: Map<String, String>?): Int?
}

@Service
class HomeServiceImpl : HomeService{
    @Autowired
    var homeDao : HomeDao? = null

    override fun join(data: Map<String, String>?): Int? {
        return homeDao?.insert(data)
    }

}

