#!/bin/bash

function generate_ip {
    echo $(( $RANDOM % 256 )).$(( $RANDOM % 256 )).$(( $RANDOM % 256 )).$(( $RANDOM % 256 ))
}

function generate_answer_code {
    # 200 - OK. "Успешно". Запрос успешно обработан. Что значит "успешно", зависит от метода HTTP, который был запрошен.
    # 201 - Created. "Создано". Запрос успешно выполнен и в результате был создан ресурс.
    # 400 - Bad Request. "Плохой запрос". Этот ответ означает, что сервер не понимает запрос из-за неверного синтаксиса.
    # 401 - Unauthorized. "Неавторизованно". Для получения запрашиваемого ответа нужна аутентификация. Статус похож на статус 403, но в этом случае аутентификация возможна.
    # 403 - Forbidden. "Запрещено". У клиента нет прав доступа к содержимому, поэтому сервер отказывается дать надлежащий ответ.
    # 404 - Not Found. "Не найден". Сервер не может найти запрашиваемый ресурс. Код этого ответа, наверно, самый известный из-за частоты его появления в вебе.
    # 500 - Internal Server Error. "Внутренняя ошибка сервера". Сервер столкнулся с ситуацией, которую он не знает как обработать.
    # 501 - Not Implemented. "Не выполнено". Метод запроса не поддерживается сервером и не может быть обработан.
    # 502 - Bad Gateway. "Плохой шлюз". Эта ошибка означает что сервер, во время работы в качестве шлюза для получения ответа, нужного для обработки запроса, получил недействительный (недопустимый) ответ.
    # 503 - Service Unavailable. "Сервис недоступен". Сервер не готов обрабатывать запрос. Зачастую причинами являются отключение сервера или то, что он перегружен.

    ANSWER_CODES=(200 201 400 401 403 404 500 501 502 503)
    echo ${ANSWER_CODES[$(( $RANDOM % 10 ))]}
}

function generate_method {
    METHODS=(GET POST PUT PATCH DELETE)
    echo ${METHODS[$(( $RANDOM % 5 ))]}
}

function generate_timestamp {
    date -d @$1 +"%d/%b/%Y:%T %z" # @ - не выводить текущую команду
}

function generate_url {
    WORDS=(some really cool site awesome dude chicks happy interesting wonderful thing)
    DOMAIN_ZONE=(ru com biz info com org net)
    PAGE=(index omg rtfm lol asap btw p2p acab gtfo)
    
    for (( i=0; i<3; i++ ))
    do
        SITE=${SITE}${WORDS[$(( $RANDOM % 11 ))]} # конкатенируем по 1 WORDS каждую итерацию
    done

    echo "http://www.$SITE.${DOMAIN_ZONE[$(( $RANDOM % 7 ))]}/${PAGE[$(( $RANDOM % 9 ))]}.html"
}

function generate_agent {
    AGENTS=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler and bot" "Library and net tool")
    echo ${AGENTS[$(( $RANDOM % 8 ))]}
}

function generate_log {
    FILENAME=$1 # имя файла в формате 01, 02...
    DATETIME=$2 # время в секундах с 1970 года (см. main.sh)
    NOTES=$(( 100 + $RANDOM % 901 )) # число записей

    > $FILENAME.log # создается файл (> - аналог touch, только если file существовал, ошибок не будет)

    for (( i=0; i<$NOTES; i++ ))
    do
        DATETIME=$(( $DATETIME + 1 + $RANDOM % 85 ))
        IP=$(generate_ip)
        TIMESTAMP=$(generate_timestamp $DATETIME)
        METHOD=$(generate_method)
        STATUS=$(generate_answer_code)
        URL=$(generate_url)
        AGENT=$(generate_agent)
    
        echo "$IP - nginx [$TIMESTAMP] \"$METHOD /index.html HTTP/1.1\" $STATUS 1234 \"$URL\" \"$AGENT\"" >> $FILENAME.log
    done
}









