{**
 * templates/frontend/pages/userLogin.tpl
 *
 * Copyright (c) 2014-2024 Simon Fraser University
 * Copyright (c) 2003-2024 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * User login form.
 *
 *}
{include file="frontend/components/header.tpl" pageTitle="user.login"}

<main class="container main__content" id="main">
	<div class="row">
		<div class="offset-md-1 col-md-10 offset-lg-2 col-lg-8">
			<header class="main__header">
				<h1 class="main__title">
					<span>{translate key="user.login"}</span>
				</h1>
			</header>

			{* A login message may be displayed if the user was redireceted to the
			   login page from another request. Examples include if login is required
			   before dowloading a file. *}
			{if $loginMessage}
				<p>
					{translate key=$loginMessage}
				</p>
			{/if}

			<form id="login" method="post" action="{$loginUrl}">
				{csrf}

				{if $error}
					{translate key=$error reason=$reason}
				{/if}

				<input type="hidden" name="source" value="{$source|strip_unsafe_html|escape}"/>

				<fieldset>
					<div class="form-group">
						<label for="username">
							{translate key="user.username"}
							<span class="required">*</span>
							<span class="visually-hidden">
								{translate key="common.required"}
							</span>
						</label>
						<input class="form-control" type="text" name="username" id="username" value="{$username|default:""|escape}" maxlength="32" required>
					</div>

					<div class="form-group">
						<label for="password">
							{translate key="user.password"}
							<span class="required">*</span>
							<span class="visually-hidden">
								{translate key="common.required"}
							</span>
						</label>
						<input class="form-control" type="password" name="password" id="password" value="{$password|default:""|escape}" password="true" maxlength="32" required>

						<div class="form-check">
							<input class="form-check-input" type="checkbox" name="remember" id="remember" value="1" checked="$remember">
							<label class="form-check-label" for="remember">
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
		</div>
	</div><!-- .row -->
</main>

{include file="frontend/components/footer.tpl"}
