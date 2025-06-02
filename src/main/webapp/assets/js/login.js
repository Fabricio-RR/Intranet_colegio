document.addEventListener('DOMContentLoaded', function () {
    const dniInput = document.getElementById('dni');
    const passwordInput = document.getElementById('password');
    const dniErrorIcon = document.getElementById('dni-error-icon');
    const passwordErrorIcon = document.getElementById('password-error-icon');
    const dniErrorSmall = document.getElementById('dni-error');
    const passwordErrorSmall = document.getElementById('password-error');
    const togglePassword = document.getElementById('togglePassword');
    const loginForm = document.querySelector('form');
    const errorMsg = document.getElementById('errorMsg');
    const successMsg = document.getElementById('successMsg');

    // Mostrar/ocultar contraseña
    if (togglePassword) {
        togglePassword.addEventListener('click', function () {
            const icon = this.querySelector('i');
            passwordInput.type = passwordInput.type === 'password' ? 'text' : 'password';
            icon.classList.toggle('fa-eye');
            icon.classList.toggle('fa-eye-slash');
        });
    }

    // Función para mostrar error
    function showError(element, message, icon) {
        if (element && icon) {
            element.textContent = message;
            element.classList.remove('hidden');
            icon.classList.remove('hidden');
            const input = element.closest('.form-group')?.querySelector('input');
            if (input) input.classList.add('input-error');
        }
    }

    // Función para ocultar error
    function hideError(element, icon) {
        if (element && icon) {
            element.classList.add('hidden');
            icon.classList.add('hidden');
            const input = element.closest('.form-group')?.querySelector('input');
            if (input) input.classList.remove('input-error');
        }
    }

    // Validación en tiempo real para DNI
    dniInput?.addEventListener('input', () => {
        dniInput.value = dniInput.value.replace(/[^0-9]/g, '').slice(0, 8);

        if (dniInput.value.length !== 8) {
            showError(dniErrorSmall, 'El DNI debe contener exactamente 8 dígitos numéricos.', dniErrorIcon);
        } else {
            hideError(dniErrorSmall, dniErrorIcon);
        }

        if (errorMsg) errorMsg.style.display = 'none';
        if (successMsg) successMsg.style.display = 'none';
    });

    // Validación en tiempo real para contraseña
    passwordInput?.addEventListener('input', () => {
        hideError(passwordErrorSmall, passwordErrorIcon);
        hideError(dniErrorSmall, dniErrorIcon);
        if (errorMsg) errorMsg.style.display = 'none';
        if (successMsg) successMsg.style.display = 'none';
    });

    // Validación final al enviar
    loginForm?.addEventListener('submit', function (event) {
        let isValid = true;

        const dniValue = dniInput.value.trim();
        const passwordValue = passwordInput.value.trim();

        if (!/^\d{8}$/.test(dniValue)) {
            showError(dniErrorSmall, 'El DNI debe contener exactamente 8 dígitos numéricos.', dniErrorIcon);
            isValid = false;
        } else {
            hideError(dniErrorSmall, dniErrorIcon);
        }

        if (passwordValue === '') {
            showError(passwordErrorSmall, 'La contraseña no puede estar vacía.', passwordErrorIcon);
            isValid = false;
        } else {
            hideError(passwordErrorSmall, passwordErrorIcon);
        }

        if (!isValid) {
            event.preventDefault();
        }
    });

    // Si hay mensaje de error desde el servidor
    if (errorMsg) {
        dniInput.value = '';
        passwordInput.value = '';
        dniInput.focus();
    }

    // Si hay mensaje de éxito desde el servidor
    if (successMsg) {
        dniInput.value = '';
        passwordInput.value = '';
        dniInput.focus();

        // Ocultar mensaje de éxito automáticamente a los 4 segundos
        setTimeout(() => {
            successMsg.style.display = 'none';
        }, 4000);
    }
});
