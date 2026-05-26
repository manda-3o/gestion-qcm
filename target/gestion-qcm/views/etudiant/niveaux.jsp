<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="currentPage" value="niveaux" />
<c:set var="pageTitle"   value="Liste par Niveau" />
<jsp:include page="/WEB-INF/header.jsp" />

<!-- ─── Filtre niveau + effectif ─────────────────────────── -->
<div class="d-flex align-items-center gap-3 mb-4 flex-wrap">
    <form method="get" action="${pageContext.request.contextPath}/niveaux" class="d-flex align-items-center gap-2">
        <label class="form-label mb-0" style="white-space:nowrap;font-size:11px;font-weight:700;text-transform:uppercase;color:var(--muted)">
            Filtrer par niveau :
        </label>
        <select name="niveau" class="form-select" style="width:130px" onchange="this.form.submit()">
            <c:forEach var="n" items="${niveaux}">
                <option value="${n}" ${niveau == n ? 'selected' : ''}>${n}</option>
            </c:forEach>
        </select>
    </form>

    <div class="ms-auto">
        <div class="card mb-0" style="background:#EEF2FF;border-color:#C5D0FA">
            <div class="card-body py-2 px-3 d-flex align-items-center gap-3">
                <i class="bi bi-people-fill text-primary" style="font-size:22px"></i>
                <div>
                    <div style="font-size:11px;color:#3B5BDB">Effectif total — ${niveau}</div>
                    <div style="font-size:22px;font-weight:700;color:#3B5BDB;line-height:1.1">
                        ${effectif} étudiant<c:if test="${effectif > 1}">s</c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ─── Tableau des étudiants du niveau ──────────────────── -->
<div class="card">
    <div class="card-body p-0">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>N°</th><th>Nom</th><th>Prénoms</th>
                    <th>Niveau</th><th>Email</th><th>Note récente</th>
                </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty etudiants}">
                    <tr><td colspan="6" class="text-center text-muted py-4">Aucun étudiant en ${niveau}</td></tr>
                </c:when>
                <c:otherwise>
                <c:forEach var="et" items="${etudiants}">
                    <%-- Trouver la dernière note --%>
                    <c:set var="lastNote" value="—"/>
                    <c:set var="lastNoteVal" value="-1"/>
                    <c:forEach var="ex" items="${examens}">
                        <c:if test="${ex.numEtudiant == et.numEtudiant}">
                            <c:set var="lastNote"    value="${ex.note}"/>
                            <c:set var="lastNoteVal" value="${ex.note}"/>
                        </c:if>
                    </c:forEach>
                    <tr>
                        <td><strong style="color:#3B5BDB">${et.numEtudiant}</strong></td>
                        <td>
                            <span class="avatar" style="background:#3B5BDB">${et.initiales}</span>
                            ${et.nom}
                        </td>
                        <td>${et.prenoms}</td>
                        <td><span class="badge badge-niveau">${et.niveau}</span></td>
                        <td class="text-muted" style="font-size:11px">${et.adrEmail}</td>
                        <td>
                            <c:choose>
                                <c:when test="${lastNoteVal >= 0}">
                                    <span class="badge ${lastNoteVal >= 5 ? 'badge-note-ok' : 'badge-note-ko'}">
                                        ${lastNote}/10
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">—</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/footer.jsp" />
