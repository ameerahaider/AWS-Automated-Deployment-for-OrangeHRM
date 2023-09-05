resource "aws_launch_template" "launch_template" {
  name_prefix            = "${var.name_prefix}-launch-template"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  user_data              = base64encode(var.user_data)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                    = "${var.name_prefix}-ASG"
  desired_capacity        = var.desired_capacity
  max_size                = var.max_size
  min_size                = var.min_size
  vpc_zone_identifier     = var.private_subnet_ids
  target_group_arns       = var.target_group_arns
  health_check_type       = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      health_check_grace_period,
      min_size,
      max_size,
      desired_capacity,
    ]
  }
}

resource "aws_autoscaling_policy" "step_scale_up" {
  name                  = "${var.name_prefix}-scale-up"
  policy_type           = "StepScaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name

  step_adjustment {
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = 50
    scaling_adjustment         = 1
  }

  step_adjustment {
    metric_interval_lower_bound = 50
    scaling_adjustment         = 1
  }

  adjustment_type = "ChangeInCapacity"
}


resource "aws_autoscaling_policy" "step_scale_down" {
  name                   = "${var.name_prefix}-scale-down"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.name_prefix}-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "This metric checks CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.step_scale_up.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.name_prefix}-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 10
  alarm_description   = "This metric checks CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.step_scale_down.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}
