package king

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class KingApplication

fun main(args: Array<String>) {
    runApplication<KingApplication>(*args)
}
