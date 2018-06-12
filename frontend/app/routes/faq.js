import Route from '@ember/routing/route';

export default Route.extend({
  model(){
    return [
      'survey',
      'quality',
      'impact',
      'tv-rankings',
      'representative',
      'consumption',
      'binding',
      'minorities',
      'finances',
      'business-model',
      'who-are-you',
      'data-privacy',
      'source-code',
      'help',
      'missing'
    ];
  }
});
