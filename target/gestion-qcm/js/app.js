/* GestionQCM — app.js */

// Auto-dismiss alerts after 4s
document.addEventListener('DOMContentLoaded', function () {
    setTimeout(function () {
        document.querySelectorAll('.alert.fade.show').forEach(function (el) {
            var alert = bootstrap.Alert.getOrCreateInstance(el);
            alert.close();
        });
    }, 4000);

    // Highlight radio option on click
    document.querySelectorAll('.radio-opt').forEach(function (opt) {
        opt.addEventListener('click', function () {
            document.querySelectorAll('.radio-opt').forEach(function (o) { o.classList.remove('selected'); });
            opt.classList.add('selected');
            var radio = opt.querySelector('input[type=radio]');
            if (radio) radio.checked = true;
        });
    });

    // Confirm delete
    document.querySelectorAll('[data-confirm]').forEach(function (btn) {
        btn.addEventListener('click', function (e) {
            if (!confirm(btn.getAttribute('data-confirm'))) e.preventDefault();
        });
    });
});
