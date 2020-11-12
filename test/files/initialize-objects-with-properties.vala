// vala-lint=skip-file

int main (string[] args) {
    var entry = new Clutter.TransitionGroup ();
    entry.duration = 400;

    var transition = new Clutter.KeyframeTransition ("opacity");
    transition.duration = 200;
    transition.remove_on_complete = true;
    transition.progress_mode = Clutter.AnimationMode.LINEAR;

    var shadow_transition = new PropertyTransition ("shadow-opacity");
    shadow_transition.duration = MultitaskingView.ANIMATION_DURATION;
    shadow_transition.remove_on_complete = true;
    shadow_transition.progress_mode = MultitaskingView.ANIMATION_MODE;

    var container = new WindowCloneContainer (true);
    container.padding_top = TOP_GAP;
    container.padding_left = container.padding_right = BORDER;
    container.padding_bottom = BOTTOM_GAP;

    var clone = new SafeWindowClone (window, true);
    clone.x = actor.x;
    clone.y = actor.y;

    var icon = new WindowIcon (window, dock_settings.IconSize, ui_scale_factor, true);
    icon.reactive = true;
    icon.opacity = 100;
    icon.x_expand = true;
    icon.y_expand = true;
    icon.x_align = ActorAlign.CENTER;
    icon.y_align = ActorAlign.CENTER;

    var effect = new ShadowEffect (40, 5);
    effect.css_class = "workspace";

    return 0;
}
