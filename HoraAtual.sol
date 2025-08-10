// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HoraAtual {
    struct DataHora {
        uint16 ano;
        uint8 mes;
        uint8 dia;
        uint8 hora;
        uint8 minuto;
        uint8 segundo;
    }

    // Retorna o timestamp atual (segundos desde 1/1/1970)
    function pegarTimestamp() public view returns (uint256) {
        return block.timestamp;
    }

    // Converte o timestamp atual em ano, mês, dia, hora, minuto e segundo
    function pegarDataHora() public view returns (DataHora memory) {
        uint256 ts = block.timestamp;

        uint256 SECONDS_PER_DAY = 24 * 60 * 60;
        uint256 SECONDS_PER_HOUR = 60 * 60;
        uint256 SECONDS_PER_MINUTE = 60;

        uint256 daysSinceEpoch = ts / SECONDS_PER_DAY;

        uint16 ano = 1970;
        uint256 daysInYear;

        // Calcula o ano
        while (true) {
            daysInYear = isLeapYear(ano) ? 366 : 365;
            if (daysSinceEpoch < daysInYear) {
                break;
            }
            daysSinceEpoch -= daysInYear;
            ano++;
        }

        uint8 mes = 1;
        uint8[12] memory daysInMonths = [
            31,
            uint8(isLeapYear(ano) ? 29 : 28),
            31,
            30,
            31,
            30,
            31,
            31,
            30,
            31,
            30,
            31
        ];

        // Calcula o mês
        for (uint8 i = 0; i < 12; i++) {
            if (daysSinceEpoch < daysInMonths[i]) {
                break;
            }
            daysSinceEpoch -= daysInMonths[i];
            mes++;
        }

        // O dia é o resto dos dias contados + 1 (pois começa em 1)
        uint8 dia = uint8(daysSinceEpoch + 1);

        // Calcula hora, minuto e segundo dentro do dia
        uint256 secsToday = ts % SECONDS_PER_DAY;
        uint8 hora = uint8(secsToday / SECONDS_PER_HOUR);
        uint8 minuto = uint8((secsToday % SECONDS_PER_HOUR) / SECONDS_PER_MINUTE);
        uint8 segundo = uint8(secsToday % SECONDS_PER_MINUTE);

        return DataHora(ano, mes, dia, hora, minuto, segundo);
    }

    // Função auxiliar para verificar se o ano é bissexto
    function isLeapYear(uint16 ano) internal pure returns (bool) {
        if (ano % 4 != 0) return false;
        if (ano % 100 != 0) return true;
        if (ano % 400 != 0) return false;
        return true;
    }
}
