module.exports = {
    hooks: {},
    blocks: {
        response: {
            process: function(block) {
                result = "";

                if (block.kwargs['header']) {
                    result += "<pre class='response-header'>" + block.kwargs['header'] + "</pre>";
                }
                result += "<pre class='response-body'>" + block.body + "</pre>";

                return result;
            }
        },
        command: {
            process: function(block) {
                return "<pre class='command-line'>" + block.body + "</pre>";
            }
        }
    },
    filters: {}
};
