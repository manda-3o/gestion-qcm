<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="currentPage" value="qcm" />
<c:set var="pageTitle"   value="Questions QCM" />
<jsp:include page="/WEB-INF/header.jsp" />

<!-- ─── Barre de recherche ───────────────────────────────── -->
<div class="d-flex gap-2 mb-3 align-items-center">
    <form method="get" action="${pageContext.request.contextPath}/qcm"
          class="d-flex gap-2 flex-grow-1">
        <div class="input-group" style="max-width:360px">
            <span class="input-group-text bg-white border-end-0">
                <i class="bi bi-search text-muted"></i>
            </span>
            <input type="text" name="search" class="form-control border-start-0"
                   placeholder="Rechercher une question..."
                   value="${search}">
        </div>
        <button type="submit" class="btn btn-outline-primary btn-sm">Filtrer</button>
        <a href="${pageContext.request.contextPath}/qcm" class="btn btn-outline-secondary btn-sm">Réinitialiser</a>
    </form>
    <button class="btn btn-primary btn-sm ms-auto"
            data-bs-toggle="modal" data-bs-target="#modalQcm">
        <i class="bi bi-plus-lg"></i> Ajouter une question
    </button>
</div>

<!-- ─── Tableau ───────────────────────────────────────────── -->
<div class="card">
    <div class="card-body p-0" style="overflow-x:auto">
        <table class="table table-hover mb-0" style="min-width:700px">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Question</th>
                    <th>Rép. A</th><th>Rép. B</th><th>Rép. C</th><th>Rép. D</th>
                    <th>Bonne</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty qcmList}">
                    <tr><td colspan="8" class="text-center text-muted py-4">Aucune question trouvée</td></tr>
                </c:when>
                <c:otherwise>
                <c:forEach var="q" items="${qcmList}" varStatus="st">
                <tr>
                    <td class="text-muted fw-bold">${st.index + 1}</td>
                    <td style="max-width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"
                        title="${q.question}">${q.question}</td>
                    <td style="font-size:11px;${q.bonne == 'reponse1' ? 'color:#059669;font-weight:700' : ''};max-width:90px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
                        ${q.reponse1}</td>
                    <td style="font-size:11px;${q.bonne == 'reponse2' ? 'color:#059669;font-weight:700' : ''};max-width:90px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
                        ${q.reponse2}</td>
                    <td style="font-size:11px;${q.bonne == 'reponse3' ? 'color:#059669;font-weight:700' : ''};max-width:90px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
                        ${q.reponse3}</td>
                    <td style="font-size:11px;${q.bonne == 'reponse4' ? 'color:#059669;font-weight:700' : ''};max-width:90px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
                        ${q.reponse4}</td>
                    <td>
                        <span class="badge" style="background:#D1FAE5;color:#059669">${q.bonneLabel}</span>
                    </td>
                    <td>
                        <!-- Modifier -->
                        <button class="btn btn-outline-secondary btn-sm"
                                data-bs-toggle="modal" data-bs-target="#modalQcm"
                                onclick="fillQcmForm(${q.numQuest},'${q.question.replace("'","\\'")}','${q.reponse1.replace("'","\\'")}','${q.reponse2.replace("'","\\'")}','${q.reponse3.replace("'","\\'")}','${q.reponse4.replace("'","\\'")}','${q.bonne}')">
                            <i class="bi bi-pencil"></i>
                        </button>
                        <!-- Supprimer -->
                        <form method="post" action="${pageContext.request.contextPath}/qcm" class="d-inline">
                            <input type="hidden" name="action"     value="delete">
                            <input type="hidden" name="num_quest"  value="${q.numQuest}">
                            <button type="submit" class="btn btn-outline-danger btn-sm"
                                    data-confirm="Supprimer cette question ?">
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

<!-- ═══ Modal Ajout / Modification QCM ═════════════════════ -->
<div class="modal fade" id="modalQcm" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/qcm" id="formQcm">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalQcmTitle">Nouvelle question QCM</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action"    id="qcmAction"  value="insert">
                    <input type="hidden" name="num_quest" id="qcmId"      value="">

                    <div class="mb-3">
                        <label class="form-label">Intitulé de la question</label>
                        <input type="text" name="question" id="qcmQuestion"
                               class="form-control" required>
                    </div>
                    <div class="row g-2">
                        <div class="col-md-6">
                            <label class="form-label">Réponse A</label>
                            <input type="text" name="reponse1" id="qcmR1" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Réponse B</label>
                            <input type="text" name="reponse2" id="qcmR2" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Réponse C</label>
                            <input type="text" name="reponse3" id="qcmR3" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Réponse D</label>
                            <input type="text" name="reponse4" id="qcmR4" class="form-control" required>
                        </div>
                    </div>
                    <div class="mt-3">
                        <label class="form-label">Bonne réponse</label>
                        <select name="bonne" id="qcmBonne" class="form-select" required>
                            <option value="reponse1">Réponse A</option>
                            <option value="reponse2">Réponse B</option>
                            <option value="reponse3">Réponse C</option>
                            <option value="reponse4">Réponse D</option>
                        </select>
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
function fillQcmForm(id, question, r1, r2, r3, r4, bonne) {
    document.getElementById('modalQcmTitle').textContent = 'Modifier la question';
    document.getElementById('qcmAction').value   = 'update';
    document.getElementById('qcmId').value       = id;
    document.getElementById('qcmQuestion').value = question;
    document.getElementById('qcmR1').value       = r1;
    document.getElementById('qcmR2').value       = r2;
    document.getElementById('qcmR3').value       = r3;
    document.getElementById('qcmR4').value       = r4;
    document.getElementById('qcmBonne').value    = bonne;
}
document.getElementById('modalQcm').addEventListener('hidden.bs.modal', function () {
    document.getElementById('modalQcmTitle').textContent = 'Nouvelle question QCM';
    document.getElementById('qcmAction').value = 'insert';
    document.getElementById('qcmId').value     = '';
    document.getElementById('formQcm').reset();
});
</script>

<jsp:include page="/WEB-INF/footer.jsp" />
