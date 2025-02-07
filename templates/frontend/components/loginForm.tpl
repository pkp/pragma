{**
 * templates/frontend/components/registrationForm.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display the basic registration form fields
 *
 * @uses $loginUrl string URL to post the login request
 * @uses $source string Optional URL to redirect to after successful login
 * @uses $username string Username
 * @uses $password string Password
 * @uses $remember boolean Should logged in cookies be preserved on this computer
 * @uses $disableUserReg boolean Can users register for this site?
 *}

<form method="post" action="{$loginUrl}">
	{csrf}
	<input type="hidden" name="source" value="{$source|strip_unsafe_html|escape}"/>

	<fieldset>
		<div class="form-group">
			<label for="usernameModal" class="form-label">
				{translate key="user.username"}
				<span class="required" aria-hidden="true">*</span>
				<span class="visually-hidden">
					{translate key="common.required"}
				</span>
			</label>
			<input type="text" class="form-control" name="username" id="usernameModal" value="{$username|default:""|escape}"
			       maxlength="32" required>
		</div>
		<div class="form-group">
			<label for="passwordModal" class="form-label">
				{translate key="user.password"}
				<span class="required" aria-hidden="true">*</span>
				<span class="visually-hidden">
					{translate key="common.required"}
				</span>
			</label>
			<input type="password" class="form-control" name="password" id="passwordModal" value="{$password|default:""|escape}"
			       maxlength="32" required>

			<div class="form-check">
				<input type="checkbox" class="form-check-input" name="remember" id="rememberModal" value="1"
				       checked="$remember">
				<label for="rememberModal" class="form-check-label">
						{translate key="user.login.rememberUsernameAndPassword"}
				</label>
			</div>
		</div>

		{* recaptcha spam blocker *}
		{if $recaptchaPublicKey}
			<div class="form-group">
				<fieldset class="recaptcha_wrapper">
					<div class="fields">
						<div class="recaptcha">
							<div class="g-recaptcha" data-sitekey="{$recaptchaPublicKey|escape}">
							</div><label for="g-recaptcha-response" style="display:none;" hidden>Recaptcha response</label>
						</div>
					</div>
				</fieldset>
			</div>
		{/if}

		{* altcha spam blocker *}
		{if $altchaEnabled}
			<fieldset class="altcha_wrapper">
				<div class="fields">
					<altcha-widget challengejson='{$altchaChallenge|@json_encode}' floating></altcha-widget>
				</div>
			</fieldset>
		{/if}

		<div class="form-group">
			<button class="btn btn-primary" type="submit">
				{translate key="user.login"}
			</button>

			{if !$disableUserReg}
				{capture assign="registerUrl"}{url page="user" op="register" source=$source}{/capture}
				<a href="{$registerUrl}" class="btn btn-secondary">
					{translate key="user.login.registerNewAccount"}
				</a>
			{/if}

			<br><br>
			<a href="{url page="login" op="lostPassword"}">
				{translate key="user.login.forgotPassword"}
			</a>
		</div>
	</fieldset>
</form>
