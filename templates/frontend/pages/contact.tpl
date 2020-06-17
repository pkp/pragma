{**
 * templates/frontend/pages/contact.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to view the press's contact details.
 *
 * @uses $currentContext Journal|Press The current journal or press
 * @uses $mailingAddress string Mailing address for the journal/press
 * @uses $contactName string Primary contact name
 * @uses $contactTitle string Primary contact title
 * @uses $contactAffiliation string Primary contact affiliation
 * @uses $contactPhone string Primary contact phone number
 * @uses $contactEmail string Primary contact email address
 * @uses $supportName string Support contact name
 * @uses $supportPhone string Support contact phone number
 * @uses $supportEmail string Support contact email address
 *}
{include file="frontend/components/header.tpl" pageTitle="about.contact"}

<main class="container main__content" id="main">
	<div class="row">
		<div class="offset-md-1 col-md-10 offset-lg-2 col-lg-8">
			<header class="main__header">
				<h1 class="main__title">
					<span>{translate key="about.contact"}</span>
				</h1>
				{include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="contact" sectionTitleKey="about.contact"}
			</header>

			{* Contact section *}
			{if $mailingAddress}
				<section>
					<h2>
						{translate key="common.mailingAddress"}
					</h2>
					<address>
						{$mailingAddress|nl2br|strip_unsafe_html}
					</address>
				</section>
			{/if}

			{* Primary contact *}
			{if $contactTitle || $contactName || $contactAffiliation || $contactPhone || $contactEmail}
				<section>
					<h2>
						{translate key="about.contact.principalContact"}
					</h2>
					<address>
						{if $contactName}
							<strong>{$contactName|escape}</strong><br>
						{/if}
						{if $contactTitle}
							{$contactTitle|escape}<br>
						{/if}
						{if $contactAffiliation}
							{$contactAffiliation|strip_unsafe_html}<br>
						{/if}
						{if $contactPhone}
							{translate key="about.contact.phone"} <a href="tel:{$contactPhone|escape}">{$contactPhone|escape}</a><br>
						{/if}
						{if $contactEmail}
							{translate key="about.contact.email"} {mailto address=$contactEmail encode='javascript'}<br>
						{/if}
					</address>
				</section>
			{/if}

			{* Technical contact *}
			{if $supportName || $supportPhone || $supportEmail}
				<section>
					<h2>
						{translate key="about.contact.supportContact"}
					</h2>
					<address>
						{if $supportName}
							<strong>{$supportName|escape}</strong><br>
						{/if}
						{if $supportPhone}
							{translate key="about.contact.phone"} <a href="tel:{$supportPhone|escape}">{$supportPhone|escape}</a><br>
						{/if}
						{if $supportEmail}
							{translate key="about.contact.email"} {mailto address=$supportEmail encode='javascript'}<br>
						{/if}
					</address>
				</section>
			{/if}
		</div>
	</div>
</main>

{include file="frontend/components/footer.tpl"}
