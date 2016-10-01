def clients_url
  base + '/clients'
end

def client_url(client_id)
  clients_url + "/#{client_id}"
end

def suites_url
  base + '/suites'
end

def suite_url(suite_id)
  suites_url + "#{suite_id}"
end

def reservations_url
  base + '/reservations'
end

def reservation_url(reservation_id)
  reservations_url + "/#{reservation_id}"
end

def accepted_reservations_url
  base + '/accepted_reservations'
end

def reservation_url(reservation_id)
  accepted_reservations_url + "/#{reservation_id}"
end

def unaccepted_reservations_url
  base + '/unaccepted_reservations'
end

def unaccepted_reservation_url(reservation_id)
  unaccepted_reservations_url + "/#{reservation_id}"
end

def base
  '/api'
end
