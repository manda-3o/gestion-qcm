<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="currentPage" value="etudiants" />
<c:set var="pageTitle"   value="Gestion des Étudiants" />
<jsp:include page="/WEB-INF/header.jsp" />

<!-- ─── Barre de recherche & actions ─────────────────────── -->
<div class="d-flex gap-2 mb-3 align-items-center flex-wrap">
    <form method="get" action="${pageContext.request.contextPath}/etudiants"
          class="d-flex gap-2 flex-grow-1">
        <div class="input-group" style="max-width:320px">
            <span class="input-group-text bg-white border-end-0">
                <i class="bi bi-search text-muted"></i>
            </span>
            <input type="text" name="search" class="form-control border-start-0"
                   placeholder="Rechercher numéro, nom, prénom..."
                   value="${search}">
        </div>
        <select name="niveau" class="form-select" style="width:140px">
            <option value="">Tous niveaux</option>
            <c:forEach var="n" items="${niveaux}">
                <option value="${n}" ${filterNiveau == n ? 'selected' : ''}>${n}</option>
            </c:forEach>
        </select>
        <button type="submit" class="btn btn-outline-primary btn-sm">
            <i class="bi bi-filter"></i> Filtrer
        </button>
        <a href="${pageContext.request.contextPath}/etudiants" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-x-lg"></i> Réinitialiser
        </a>
    </form>
    <button class="btn btn-primary btn-sm ms-auto" data-bs-toggle="modal" data-bs-target="#modalEtu">
        <i class="bi bi-plus-lg"></i> Ajouter un étudiant
    </button>
</div>

<!-- ─── Effectif par niveau ──────────────────────────────── -->
<c:if test="${empty filterNiveau and empty search}">
<div class="card mb-3">
    <div class="card-body">
        <div class="sec-title"><i class="bi bi-people text-primary"></i>Effectif par niveau</div>
        <div class="d-flex gap-3 flex-wrap">
            <c:forEach var="n" items="${niveaux}">
                <%-- On compte dynamiquement dans la JSP --%>
                <c:set var="cnt" value="0"/>
                <c:forEach var="et" items="${etudiants}">
                    <c:if test="${et.niveau == n}"><c:set var="cnt" value="${cnt + 1}"/></c:if>
                </c:forEach>
                <div class="niv-pill">
                    <span class="niv-val">${cnt}</span>
                    <span class="niv-lbl">${n}</span>
                </div>
            </c:forEach>
            <div class="niv-pill" style="background:#FEF3C7">
                <span class="niv-val" style="color:#D97706">${etudiants.size()}</span>
                <span class="niv-lbl">Total</span>
            </div>
        </div>
    </div>
</div>
</c:if>

<!-- ─── Tableau ───────────────────────────────────────────── -->
<div class="card">
    <div class="card-body p-0">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>N°</th><th>Nom</th><th>Prénoms</th>
                    <th>Niveau</th><th>Email</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty etudiants}">
                    <tr><td colspan="6" class="text-center text-muted py-4">Aucun étudiant trouvé</td></tr>
                </c:when>
                <c:otherwise>
                <c:forEach var="et" items="${etudiants}">
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
                        <!-- Modifier -->
                        <button class="btn btn-outline-secondary btn-sm"
                                data-bs-toggle="modal" data-bs-target="#modalEtu"
                                onclick="fillEditForm('${et.numEtudiant}','${et.nom}','${et.prenoms}','${et.niveau}','${et.adrEmail}')">
                            <i class="bi bi-pencil"></i>
                        </button>
                        <!-- Supprimer -->
                        <form method="post" action="${pageContext.request.contextPath}/etudiants" class="d-inline">
                            <input type="hidden" name="action"        value="delete">
                            <input type="hidden" name="num_etudiant"  value="${et.numEtudiant}">
                            <button type="submit" class="btn btn-outline-danger btn-sm"
                                    data-confirm="Supprimer ${et.nom} ${et.prenoms} ?">
                                <i class="bi bi-trash"></i>
                            </button>
                        </form>
                    </td>
                </tr>
                </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>

<!-- ═══ Modal Ajout / Modification ══════════════════════════ -->
<div class="modal fade" id="modalEtu" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/etudiants" id="formEtu">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalEtuTitle">Nouvel étudiant</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" id="etuAction" value="insert">

                    <div class="mb-3">
                        <label class="form-label">Numéro étudiant</label>
                        <input type="text" name="num_etudiant" id="etuNum"
                               class="form-control" required placeholder="Ex: E006">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nom</label>
                        <input type="text" name="Nom" id="etuNom" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Prénoms</label>
                        <input type="text" name="Prenoms" id="etuPrenoms" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Niveau</label>
                        <select name="Niveau" id="etuNiveau" class="form-select" required>
                            <option value="L1">L1</option><option value="L2">L2</option>
                            <option value="L3">L3</option><option value="M1">M1</option>
                            <option value="M2">M2</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Adresse email</label>
                        <input type="email" name="adr_email" id="etuEmail" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg"></i> Enregistrer
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function fillEditForm(num, nom, prenoms, niveau, email) {
    document.getElementById('modalEtuTitle').textContent = 'Modifier l\'étudiant';
    document.getElementById('etuAction').value    = 'update';
    document.getElementById('etuNum').value       = num;
    document.getElementById('etuNum').readOnly    = true;
    document.getElementById('etuNom').value       = nom;
    document.getElementById('etuPrenoms').value   = prenoms;
    document.getElementById('etuNiveau').value    = niveau;
    document.getElementById('etuEmail').value     = email;
}
// Reset form when modal is closed
document.getElementById('modalEtu').addEventListener('hidden.bs.modal', function () {
    document.getElementById('modalEtuTitle').textContent = 'Nouvel étudiant';
    document.getElementById('etuAction').value = 'insert';
    document.getElementById('etuNum').readOnly = false;
    document.getElementById('formEtu').reset();
});
</script>

<jsp:include page="/WEB-INF/footer.jsp" />
