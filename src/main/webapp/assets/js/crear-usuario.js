const contextPath = document.body.getAttribute("data-context-path") || '';

function togglePassword(idInput, idIcono) {
    const input = document.getElementById(idInput);
    const icono = document.getElementById(idIcono);

    if (input.type === "password") {
        input.type = "text";
        if (icono) icono.classList.replace("fa-eye", "fa-eye-slash");
    } else {
        input.type = "password";
        if (icono) icono.classList.replace("fa-eye-slash", "fa-eye");
    }
}

document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("formCrearUsuario");

    // Funciones internas para alertas
    function mostrarError(mensaje) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: mensaje,
            confirmButtonColor: '#110d59'
        });
    }

    function mostrarExito(mensaje, callback) {
        Swal.fire({
            icon: 'success',
            title: 'Éxito',
            text: mensaje,
            confirmButtonColor: '#110d59'
        }).then(() => {
            if (callback) callback();
        });
    }

    // Vista previa de imagen
    document.getElementById("previewFoto").addEventListener("click", () => {
        document.getElementById("inputFoto").click();
    });

    document.getElementById("inputFoto").addEventListener("change", (e) => {
        const file = e.target.files[0];
        if (file && file.type.startsWith("image/")) {
            const reader = new FileReader();
            reader.onload = (e) => {
                document.getElementById("previewFoto").src = e.target.result;
            };
            reader.readAsDataURL(file);
        }
    });

    // Validar y enviar formulario
    form.addEventListener("submit", async (e) => {
        e.preventDefault();

        const dni = document.getElementById("dni").value.trim();

        // Validar contraseñas
        const clave = document.getElementById("clave").value;
        const confirmar = document.getElementById("confirmarClave").value;
        if (clave !== confirmar) {
            mostrarError("Las contraseñas no coinciden.");
            return;
        }

        // Validar campos HTML5
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        // Validar que el DNI no exista
        try {
            const response = await fetch(`${contextPath}/usuarios?action=validar_dni&dni=${encodeURIComponent(dni)}`);
            if (!response.ok) throw new Error("No se pudo validar el DNI.");
            const result = await response.json();
            if (result.existe) {
                mostrarError("El DNI ya está registrado.");
                return;
            }
        } catch (err) {
            console.error(err);
            mostrarError("Error al validar el DNI.");
            return;
        }

        // Enviar datos
        const formData = new FormData(form);
        const rolesSeleccionados = document.querySelectorAll('input[name="roles"]:checked');
        rolesSeleccionados.forEach(cb => {
            formData.append("roles", cb.value);
        });

        Swal.fire({
            title: 'Creando usuario...',
            allowOutsideClick: false,
            didOpen: () => Swal.showLoading()
        });

        try {
            const res = await fetch(`${contextPath}/usuarios?action=crear`, {
                method: "POST",
                body: formData
            });

            Swal.close();

            if (!res.ok) {
                const errData = await res.json();
                mostrarError(errData.error || "No se pudo crear el usuario.");
                return;
            }

            const data = await res.json();
            mostrarExito(data.mensaje || "Usuario creado correctamente.", () => {
                window.location.href = `${contextPath}/usuarios`;
            });

        } catch (err) {
            console.error(err);
            Swal.close();
            mostrarError("Error inesperado al crear usuario.");
        }
    });
});
