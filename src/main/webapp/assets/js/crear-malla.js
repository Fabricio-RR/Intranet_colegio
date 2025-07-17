// assets/js/crear-malla-aperturas.js
$(document).ready(function () {
    function getUnique(arr, key) {
        // Útil para que no se repita cada opción en los combos
        const seen = {};
        return arr.filter(item => {
            if (seen[item[key]]) return false;
            seen[item[key]] = true;
            return true;
        });
    }

    // ==== Helpers para combos dependientes ====
    function cargarNiveles($anioSelect, $nivelSelect, $gradoSelect, $seccionSelect) {
        var anio = $anioSelect.val();
        $nivelSelect.html('<option value="" disabled selected>Seleccione nivel</option>').prop('disabled', true);
        $gradoSelect.html('<option value="" disabled selected>Seleccione grado</option>').prop('disabled', true);
        $seccionSelect.html('<option value="" disabled selected>Seleccione sección</option>').prop('disabled', true);

        if (!anio) return;
        var niveles = getUnique(
            aperturasSeccion.filter(a => a.idAnioLectivo == anio),
            'idNivel'
        );
        if (niveles.length > 0) {
            $.each(niveles, function (i, n) {
                $nivelSelect.append(`<option value="${n.idNivel}">${n.nombreNivel}</option>`);
            });
            $nivelSelect.prop('disabled', false);
        }
    }
    function cargarGrados($anioSelect, $nivelSelect, $gradoSelect, $seccionSelect) {
        var anio = $anioSelect.val();
        var idNivel = $nivelSelect.val();
        $gradoSelect.html('<option value="" disabled selected>Seleccione grado</option>').prop('disabled', true);
        $seccionSelect.html('<option value="" disabled selected>Seleccione sección</option>').prop('disabled', true);

        if (!anio || !idNivel) return;
        var grados = getUnique(
            aperturasSeccion.filter(a => a.idAnioLectivo == anio && a.idNivel == idNivel),
            'idGrado'
        );
        if (grados.length > 0) {
            $.each(grados, function (i, g) {
                $gradoSelect.append(`<option value="${g.idGrado}">${g.nombreGrado}</option>`);
            });
            $gradoSelect.prop('disabled', false);
        }
    }
    function cargarSecciones($anioSelect, $nivelSelect, $gradoSelect, $seccionSelect) {
        var anio = $anioSelect.val();
        var idNivel = $nivelSelect.val();
        var idGrado = $gradoSelect.val();
        $seccionSelect.html('<option value="" disabled selected>Seleccione sección</option>').prop('disabled', true);

        if (!anio || !idNivel || !idGrado) return;
        var secciones = getUnique(
            aperturasSeccion.filter(a =>
                a.idAnioLectivo == anio &&
                a.idNivel == idNivel &&
                a.idGrado == idGrado
            ),
            'idSeccion'
        );
        if (secciones.length > 0) {
            $.each(secciones, function (i, s) {
                $seccionSelect.append(`<option value="${s.idSeccion}">${s.nombreSeccion}</option>`);
            });
            $seccionSelect.prop('disabled', false);
        }
    }

    // ===== MANUAL =====
    var $anioManual    = $('#anioManual');
    var $nivelManual   = $('#nivelManual');
    var $gradoManual   = $('#gradoManual');
    var $seccionManual = $('#seccionManual');
    $anioManual.on('change', function () {
        cargarNiveles($anioManual, $nivelManual, $gradoManual, $seccionManual);
    });
    $nivelManual.on('change', function () {
        cargarGrados($anioManual, $nivelManual, $gradoManual, $seccionManual);
    });
    $gradoManual.on('change', function () {
        cargarSecciones($anioManual, $nivelManual, $gradoManual, $seccionManual);
    });

    // ===== MASIVA =====
    var $anioMasiva    = $('#anioMasiva');
    var $nivelMasiva   = $('#nivelMasiva');
    var $gradoMasiva   = $('#gradoMasiva');
    var $seccionMasiva = $('#seccionMasiva');
    $anioMasiva.on('change', function () {
        cargarNiveles($anioMasiva, $nivelMasiva, $gradoMasiva, $seccionMasiva);
    });
    $nivelMasiva.on('change', function () {
        cargarGrados($anioMasiva, $nivelMasiva, $gradoMasiva, $seccionMasiva);
    });
    $gradoMasiva.on('change', function () {
        cargarSecciones($anioMasiva, $nivelMasiva, $gradoMasiva, $seccionMasiva);
    });

    // ===== COPIAR =====
    var $anioOrigen    = $('#anioCopiar');
    var $nivelCopiar   = $('#nivelCopiar');
    var $gradoCopiar   = $('#gradoCopiar');
    var $seccionCopiar = $('#seccionCopiar');
    $anioOrigen.on('change', function () {
        cargarNiveles($anioOrigen, $nivelCopiar, $gradoCopiar, $seccionCopiar);
    });
    $nivelCopiar.on('change', function () {
        cargarGrados($anioOrigen, $nivelCopiar, $gradoCopiar, $seccionCopiar);
    });
    $gradoCopiar.on('change', function () {
        cargarSecciones($anioOrigen, $nivelCopiar, $gradoCopiar, $seccionCopiar);
    });

    // Inicializa combos según primer año seleccionado (si existe)
    if ($anioManual.val())  $anioManual.trigger('change');
    if ($anioMasiva.val())  $anioMasiva.trigger('change');
    if ($anioOrigen.val())  $anioOrigen.trigger('change');
});
