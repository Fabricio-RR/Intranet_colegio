<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <c:set var="paginaActiva" value="malla curricular" scope="request"/>
    <jsp:include page="/includes/meta.jsp" />
    <title>Crear Malla Curricular - Intranet Escolar</title>

    <!-- CSS externas -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>

<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">
<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value="Crear Malla Curricular" scope="request"/>
<c:set var="tituloPaginaMobile"  value="Crear Malla"          scope="request"/>
<c:set var="iconoPagina"         value="fas fa-layer-group"   scope="request"/>
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
<div class="container-fluid">

<form action="${pageContext.request.contextPath}/malla-curricular?action=masiva" method="post">

    <!-- Información académica -->
    <div class="card mb-4">
        <div class="card-header bg-light fw-bold">
            <i class="fas fa-info-circle me-2"></i>Información Académica
        </div>
        <div class="card-body row g-3 align-items-end">

            <!-- Año lectivo (envía nombre) -->
            <div class="col-md-2">
                <label class="form-label">Año Lectivo</label>
                <select name="anioLectivoNombre" id="anioMasiva" class="form-select" required>
                    <option value="" disabled selected>Seleccione año</option>
                    <c:forEach var="anio" items="${aniosLectivos}">
                        <option value="${anio.nombre}"
                                <c:if test="${anio.nombre == anioLectivoSel}">selected</c:if>>
                            ${anio.nombre}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- Nivel / Grado / Sección -->
            <div class="col-md-4">
                <label class="form-label">Nivel / Grado / Sección <span class="text-danger">*</span></label>
                <select name="idAperturaSeccion" id="idAperturaSeccionMasiva" class="form-select" required>
                    <option value="" disabled selected>Seleccione sección</option>
                </select>
                <div class="invalid-feedback">Seleccione nivel, grado y sección.</div>
            </div>
        </div>
    </div>

    <!-- Agregar cursos -->
    <div class="card mb-4">
        <div class="card-header bg-light fw-bold">
            <i class="fas fa-layer-group me-2"></i>Agregar Cursos a la Lista
        </div>
        <div class="card-body row g-3 align-items-end">

            <div class="col-md-4">
                <label class="form-label">Curso a agregar</label>
                <select id="selectCursoAgregar" class="form-select">
                    <option value="" disabled selected>Seleccione un curso</option>
                    <c:forEach var="curso" items="${cursos}">
                        <option value="${curso.idCurso}"
                                data-nombre="${fn:escapeXml(curso.nombreCurso)}">
                            ${curso.nombreCurso}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-md-2 d-flex align-items-end">
                <button type="button" id="btnAgregarCurso" class="btn btn-admin-primary w-100">
                    <i class="fas fa-plus"></i> Agregar
                </button>
            </div>
        </div>
    </div>

    <!-- Tabla cursos -->
    <div class="card mb-4">
        <div class="card-header bg-light fw-bold">
            <i class="fas fa-table me-2"></i>Cursos Seleccionados
        </div>
        <div class="card-body">
            <div class="table-responsive mt-3">
                <table class="table table-bordered align-middle" id="tablaCursosSeleccionados">
                    <thead class="table-light text-center">
                        <tr>
                            <th style="width:25%;">CURSO</th>
                            <th style="width:25%;">DOCENTE</th>
                            <th style="width:12%;">ORDEN</th>
                            <th style="width:15%;">ACTIVO</th>
                            <th style="width:8%;">Quitar</th>
                        </tr>
                    </thead>
                    <tbody><!-- JS inserta filas --></tbody>
                </table>
                <div id="alertaCursos" class="text-danger d-none ps-2 pb-2">
                    Agregue al menos un curso.
                </div>
            </div>
        </div>
    </div>

    <!-- id real del año (lo rellena JS) -->
    <input type="hidden" id="idAnioLectivoHidden" name="idAnioLectivo" value="${anioActual}"/>

    <div class="text-end mb-5">
        <button type="submit" class="btn btn-admin-primary">
            <i class="fas fa-save me-1"></i>Guardar Malla Masiva
        </button>
    </div>
</form>
</div>
<jsp:include page="/includes/footer.jsp" />
</main>

<!-- JavaScript -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- Map nombre→id de año -->
<script>
const añosMap = {
    <c:forEach var="a" items="${aniosLectivos}" varStatus="s">
    "${a.nombre}": ${a.idAnioLectivo}${s.last ? '' : ','}
    </c:forEach>
};
</script>

<!-- Todas las secciones -->
<script>
const seccionesData = [
<c:forEach var="aps" items="${aperturasSeccion}" varStatus="st">
{
    id   : '${aps.idAperturaSeccion}',
    anio : '${aps.anioLectivo}',   // nombre, ej. "2025"
    texto: '${fn:escapeXml(aps.nivel)} - ${fn:escapeXml(aps.grado)} "${fn:escapeXml(aps.seccion)}" (${fn:escapeXml(aps.anioLectivo)})'
}${st.last ? '' : ','}
</c:forEach>
];
</script>

<script>
document.addEventListener('DOMContentLoaded', () => {

    /* === pinta secciones y sincroniza hidden id === */
    const selAnio    = document.getElementById('anioMasiva');
    const selSeccion = document.getElementById('idAperturaSeccionMasiva');
    const hiddenId   = document.getElementById('idAnioLectivoHidden');

    function refrescarSecciones() {
        const nombre = selAnio.value;
        hiddenId.value = añosMap[nombre] ?? 0;

        selSeccion.innerHTML =
          '<option value="" disabled selected>Seleccione sección</option>';

        seccionesData
            .filter(s => s.anio === nombre)
            .forEach(s => {
                const o = document.createElement('option');
                o.value = s.id;
                o.textContent = s.texto;
                selSeccion.appendChild(o);
            });
    }
    selAnio.addEventListener('change', refrescarSecciones);
    refrescarSecciones(); // inicial

    /* === cursos dinámicos === */
    const btnAgregar   = document.getElementById('btnAgregarCurso');
    const selCurso     = document.getElementById('selectCursoAgregar');
    const tbody        = document.querySelector('#tablaCursosSeleccionados tbody');
    const alerta       = document.getElementById('alertaCursos');
    let cursosAgregados = [];

    const opcionesDocentes = `<option value="">Seleccione</option>
        <c:forEach var="d" items="${docentes}">
            <option value="${d.idUsuario}">${fn:escapeXml(d.nombres)} ${fn:escapeXml(d.apellidos)}</option>
        </c:forEach>`;

    btnAgregar.addEventListener('click', e => {
        e.preventDefault();
        const idCurso = selCurso.value;
        const nombre  = selCurso.options[selCurso.selectedIndex]?.textContent.trim() || '';
        if (!idCurso) return;
        if (cursosAgregados.includes(idCurso)) {
            Swal.fire('Advertencia', 'El curso ya fue agregado.', 'warning');
            return;
        }
        const tr = document.createElement('tr');
        tr.innerHTML =
            '<td><input type="hidden" name="idCurso[]" value="'+idCurso+'"><span class="fw-bold">'+nombre+'</span></td>'+
            '<td><select name="idDocente[]" class="form-select" required>'+opcionesDocentes+'</select></td>'+
            '<td class="text-center"><input type="number" name="orden[]" class="form-control text-center" min="1" style="max-width:80px" required></td>'+
            '<td class="text-center"><select name="activo[]" class="form-select" style="max-width:90px"><option value="1" selected>Sí</option><option value="0">No</option></select></td>'+
            '<td class="text-center"><button type="button" class="btn btn-danger btn-sm btn-quitar-curso"><i class="fas fa-trash"></i></button></td>';

        tr.querySelector('.btn-quitar-curso').addEventListener('click', () => {
            tr.remove();
            cursosAgregados = cursosAgregados.filter(id => id !== idCurso);
        });

        tbody.appendChild(tr);
        cursosAgregados.push(idCurso);
        alerta.classList.add('d-none');
    });

    /* === validación antes de enviar === */
    document.querySelector('form').addEventListener('submit', e => {
        if (tbody.children.length === 0) {
            alerta.classList.remove('d-none');
            e.preventDefault();
        }
    });
});
</script>
</body>
</html>
