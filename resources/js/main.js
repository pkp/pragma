(function() {
	if (!document.querySelector('.page_user.op_register')) {
		return;
	}

	const checkboxReviewerInterests = document.getElementById('checkbox-reviewer-interests');
	if (!checkboxReviewerInterests) {
		return;
	}

	/**
	 * Reveal the reviewer interests field on the registration form when a
	 * user has opted to register as a reviewer
	 *
	 * @see: /templates/frontend/pages/userRegister.tpl
	 */
	function reviewerInterestsToggle() {
		if (checkboxReviewerInterests.checked) {
			document.getElementById('reviewerInterests').classList.remove('hidden');
		} else {
			document.getElementById('reviewerInterests').classList.add('hidden');
		}
	}

	// Update interests on page load and when the toggled is toggled
	reviewerInterestsToggle();
	document.querySelector('#reviewerOptinGroup input').addEventListener('click', reviewerInterestsToggle);
})();

(function () {

	// Open login modal when nav menu links clicked
	document.querySelectorAll('.nmi_type_user_login').forEach((userLogin) => {
		userLogin.addEventListener('click', function (event) {
			event.preventDefault();
			const loginModal = new bootstrap.Modal('#loginModal');
			loginModal.show();
		});
	});
})();

// Not display the menu if all items are inaccessible

(function () {

	const navPrimary = document.getElementById('navigationPrimary');
	if (!navPrimary) {
		return;
	}

	if (navPrimary.childElementCount > 0) {
		return;
	}

	document.querySelector('button[data-bs-target="#mainMenu"]').hidden = true;
})();

// Toggle display of consent checkboxes in site-wide registration

(function () {
	const contextOptinGroup = document.getElementById('contextOptinGroup');
	if (!contextOptinGroup) {
		return;
	}

	const privacyVisible = 'context_privacy_visible';

	document.querySelectorAll('.registration-context__roles').forEach((context) => {
		const roleInputs = context.querySelectorAll(':scope .form-check-input');
		roleInputs.forEach((roleInput) => {
			roleInput.addEventListener('change', function () {
				const contextPrivacy = context.parentElement.querySelector(':scope .context_privacy');
				if (!contextPrivacy) {
					return;
				}

				if (this.checked) {
					if (!contextPrivacy.classList.contains(privacyVisible)) {
						contextPrivacy.classList.add(privacyVisible);
						return;
					}
				}

				for (let i = 0; i < roleInputs.length; i++) {
					const sibling = roleInputs[i];
					if (sibling === roleInput) {
						continue;
					}
					if (sibling.checked) {
						return;
					}
				}

				contextPrivacy.classList.remove(privacyVisible);
			});
		});
	});
})();
