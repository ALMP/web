# frozen_string_literal: true
Ransack::Adapters::ActiveRecord::Base.class_eval('remove_method :search')
