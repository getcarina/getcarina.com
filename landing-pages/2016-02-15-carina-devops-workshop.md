---
permalink: lp/carina-devops-workshop/
title: Sign up for a collaborative workshop with the Carina team
bodyClass: lp-carina-devops-workshop
description: Get personalized, hands-on help from Rackspace architects to adopt containers in your next project. Sign up for the collaborative workshop.
---
<div class="lp-section-hero"></div>
<header class="lp-section header">
  <div class="section-container">
    <div class="section-grid">
      <div class="lp-header">
        <h1 class="headline">Get personalized, hands-on help from Rackspace architects to adopt containers in your next project.</h1>
        <p class="lead">Sign up for a two-day collaborative session with our architects to build a prototype container-based solution tailored specifically for your project.</p>
      </div>
    </div>
  </div>
</header>
<div class="lp-section form">
  <div class="section-container">
    <div class="section-grid">
      <div class="form-aside">
        <p class="lead">Looking for ideas on how to take advantage of the benefits of containers, but not sure where to start? Carina by Rackspace makes containers clusters accessible to everyone, from beginners to professional developers. Our team can help you address your unique business needs, identify the opportunities for a managed containers environment, and help you implement a solution that’s right for you. Sign up now for a personalized two-day workshop to get started.</p>
      </div>
      <div class="lp-form" data-ng-controller="WorkshopFormCtrl as workshop">
        <form name="form" data-ng-submit="form.$valid && workshop.submitForm()" data-ng-show="workshop.status != 'submitted'">
          <div class="lead-in">Let us know how to reach you, and we’ll begin planning your personalized containers workshop.</div>
          <div class="control">
            <label for="">Your Name:</label>
            <input type="text" name="name" data-ng-model="workshop.formData.name" required placeholder="Enter your name...">
          </div>
          <div class="control">
            <label for="">Your E-mail Address:</label>
            <input type="email" name="email" data-ng-model="workshop.formData.email" required placeholder="Enter your e-mail address...">
          </div>
          <div class="control">
            <label for="">Your Phone Number:</label>
            <input type="tel" name="phone" data-ng-model="workshop.formData.phone" required placeholder="Enter your phone number...">
          </div>
          <div class="control">
            <button type="submit" data-ng-disabled="workshop.status == 'submitting'">
              Submit
            </button>
          </div>
        </form>
        <div class="form-submitted" data-ng-show="workshop.status == 'submitted'">
          <div class="lead-in">
            Thanks! One of our team members will reach out to you soon to begin planning your personalized workshop.
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<div class="lp-section more-info">
  <div class="section-container">
    <div class="section-grid">
      <div class="lp-more-info">
        <h3>Privacy Policy</h3>
        <p> Rackspace US, Inc. and its affiliates may use the information you provide on this form to send to you messages regarding products, services, and promotional offers. See Rackspace US Inc.'s <a href="http://www.rackspace.com/information/legal/privacystatement">Privacy Statement.</a></p>
      </div>
    </div>
  </div>
</div>
