import Component from '@ember/component';

export default Component.extend({
  tagName: '',
  slugArray: null,
  init() {
    this._super(...arguments);
    this.set('slugArray', [
      [
      'survey',
      'quality',
      'impact',
      ], [
      'tv-rankings',
      'representative',
      'consumption',
      ], [
      'binding',
      'minorities',
      'finances',
      ], [
      'business-model',
      'who-are-you',
      'data-privacy',
      ], [
      'source-code',
      'help',
      'missing'
      ]
    ]);
  }
});
