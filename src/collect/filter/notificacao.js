(function() {
    'use strict';

    angular.module('seeawayApp').filter('notificacaoStatus', notificacaoStatus);

    notificacaoStatus.$inject = ['NOTIFICACAO'];

    function notificacaoStatus(NOTIFICACAO) {
        return function(value) {
            value = parseInt(value);
            for (var i = 0; i <= NOTIFICACAO.STATUS.length - 1; i++) {
                if (NOTIFICACAO.STATUS[i].id === value) {
                    return NOTIFICACAO.STATUS[i].name;
                }
            }
            return '?';
        };
    }

    angular.module('seeawayApp').filter('notificacaoTipo', notificacaoTipo);

    notificacaoTipo.$inject = ['NOTIFICACAO'];

    function notificacaoTipo(NOTIFICACAO) {
        return function(value) {
            value = parseInt(value);
            for (var i = 0; i <= NOTIFICACAO.TIPO.length - 1; i++) {
                if (NOTIFICACAO.TIPO[i].id === value) {
                    return NOTIFICACAO.TIPO[i].name;
                }
            }
            return '?';
        };
    }

    angular.module('seeawayApp').filter('notificacaoAcao', notificacaoAcao);

    notificacaoAcao.$inject = ['NOTIFICACAO'];

    function notificacaoAcao(NOTIFICACAO) {
        return function(value) {
            value = parseInt(value);
            for (var i = 0; i <= NOTIFICACAO.ACAO.length - 1; i++) {
                if (NOTIFICACAO.ACAO[i].id === value) {
                    return NOTIFICACAO.ACAO[i].name;
                }
            }
            return '?';
        };
    }

    angular.module('seeawayApp').filter('notificacaoAnexo', notificacaoAnexo);

    notificacaoAnexo.$inject = ['NOTIFICACAO'];

    function notificacaoAnexo(NOTIFICACAO) {
        return function(value) {
            value = parseInt(value);
            for (var i = 0; i <= NOTIFICACAO.ANEXO.length - 1; i++) {
                if (NOTIFICACAO.ANEXO[i].id === value) {
                    return NOTIFICACAO.ANEXO[i].name;
                }
            }
            return '?';
        };
    }
})();