<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="currentPage" value="examens" />
<c:set var="pageTitle"   value="Examen en cours" />
<jsp:include page="/WEB-INF/header.jsp" />

<div class="row justify-content-center">
<div class="col-md-7">
<div class="card">
    <div class="card-body">

        <!-- En-tête : étudiant + progression -->
        <div class="d-flex justify-content-between align-items-center mb-2" style="font-size:11px;color:var(--muted)">
            <span>
                <strong>${etudiant.nom} ${etudiant.prenoms}</strong>
                &nbsp;·&nbsp;${anneeUniv}
            </span>
            <span class="badge bg-primary">Q ${current} / ${total}</span>
        </div>

        <!-- Barre de progression -->
        <div class="prog-wrap">
            <div class="prog-fill" style="width:${(current - 1) * 100 / total}%"></div>
        </div>

        <!-- Texte de la question -->
        <div class="mb-4" style="font-size:14px;font-weight:600;line-height:1.5">
            ${current}. ${question.question}
        </div>

        <!-- Formulaire réponse -->
        <form method="post" action="${pageContext.request.contextPath}/examens" id="formAnswer">
            <input type="hidden" name="action" value="answer">

            <label class="radio-opt" for="r1">
                <input type="radio" name="reponse" id="r1" value="reponse1" required>
                <span><strong class="text-muted">A.</strong> ${question.reponse1}</span>
            </label>

            <label class="radio-opt" for="r2">
                <input type="radio" name="reponse" id="r2" value="reponse2">
                <span><strong class="text-muted">B.</strong> ${question.reponse2}</span>
            </label>

            <label class="radio-opt" for="r3">
                <input type="radio" name="reponse" id="r3" value="reponse3">
                <span><strong class="text-muted">C.</strong> ${question.reponse3}</span>
            </label>

            <label class="radio-opt" for="r4">
                <input type="radio" name="reponse" id="r4" value="reponse4">
                <span><strong class="text-muted">D.</strong> ${question.reponse4}</span>
            </label>

            <div class="d-flex justify-content-between align-items-center mt-4">
                <span style="font-size:11px;color:var(--muted)">
                    Score actuel : <strong>${score}/${current - 1}</strong>
                </span>
                <button type="submit" class="btn btn-primary" id="btnNext" disabled>
                    <c:choose>
                        <c:when test="${current < total}">
                            Question suivante <i class="bi bi-arrow-right"></i>
                        </c:when>
                        <c:otherwise>
                            Terminer l'examen <i class="bi bi-check-lg"></i>
                        </c:otherwise>
                    </c:choose>
                </button>
            </div>
        </form>

    </div>
</div>
</div>
</div>

<script>
// Activer le bouton "Suivant" dès qu'une réponse est cochée
document.querySelectorAll('input[name=reponse]').forEach(function(radio) {
    radio.addEventListener('change', function () {
        document.getElementById('btnNext').disabled = false;
    });
});
// Désactiver le bouton après soumission (éviter double-clic)
document.getElementById('formAnswer').addEventListener('submit', function () {
    document.getElementById('btnNext').disabled = true;
});
</script>

<jsp:include page="/WEB-INF/footer.jsp" />
